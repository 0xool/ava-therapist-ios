//
//  AuthenticateService.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/6/23.
//

import Foundation
import SwiftUI
import Combine

import FirebaseAuth
import GoogleSignIn
import FirebaseCore

protocol AuthenticationService {
    func loginUser(email: String, password: String)
    func registerUser(name: String, email: String, password: String, mobileNumber: String)
    func checkUserStatus(loading: Binding<Bool>)
    
    func authenticateUserWithThirdParty(provider: Provider, token: String)
    func signInGoogle()
    func signOut()
}

class MainAuthenticationService: AuthenticationService {
    let authenticateRepository: AuthenticateWebRepository
    let userDBRepository: UserDBRepository
    let settingDBRepository: SettingDBRepository
    
    let appState: Store<AppState>
    
    init(appState: Store<AppState>, authenticateRepository: AuthenticateWebRepository, userDBRepository: UserDBRepository, settingDBRepository: SettingDBRepository){
        self.appState = appState
        self.authenticateRepository = authenticateRepository
        self.userDBRepository = userDBRepository
        
        self.settingDBRepository = settingDBRepository
        self.configureGID()
    }
    
    func checkUserStatus(loading: Binding<Bool>) {
        let cancelBag = CancelBag()
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                self.getUser()
            }
            .flatMap({ [self, userDBRepository] in
                loadSetting(cancelBag: cancelBag)
                return userDBRepository.loadUser()
            })
            .sink{ subscriptionCompletion in
                if let _ = subscriptionCompletion.error {
                    self.appState[\.userData.user] = .notRequested
                    loading.wrappedValue = false
                }
            } receiveValue: { user in
                PersistentManager.instance.saveUserCookieToken(token: user.token ?? "")
                self.appState[\.userData.user] = .loaded(user)
                loading.wrappedValue = false
            }
            .store(in: cancelBag)
    }
    
    func loginUser(email: String, password: String) {
        let cancelBag = CancelBag()
        self.appState[\.userData.user].setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                self.login(email: email, password: password).mapError{$0}
            }
            .flatMap({ [self, userDBRepository] in
                loadSetting(cancelBag: cancelBag)
                return userDBRepository.loadUser()
            })
            .sinkToLoadable {
                self.appState[\.userData.user] = $0
            }
            .store(in: cancelBag)
    }
    
    func authenticateUserWithThirdParty(provider: Provider, token: String){
    }
    
    func registerUser(name: String, email: String, password: String, mobileNumber: String){
        let cancelBag = CancelBag()
        self.appState[\.userData.user].setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{ [userDBRepository] _ -> AnyPublisher<Bool, Error> in
                userDBRepository.hasLoadedUser()
            }
            .flatMap{ hasLoaded in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.register(name: name, email: email, password: password, mobileNumber: mobileNumber)
                }
            }
            .flatMap({ [self, userDBRepository] in
                loadSetting(cancelBag: cancelBag)
                return userDBRepository.loadUser()
            })
            .sinkToLoadable {
                self.appState[\.userData.user] = $0
            }
            .store(in: cancelBag)
    }
    
    func signOut() {
        do {
           try Auth.auth().signOut()
        }catch{
            
        }
    }
}

// MARK: Google Sign In

extension MainAuthenticationService {
    
    func signInGoogle(){
        guard let topViewController = UIApplication.topViewController() else{
            return
        }
        
        let cancelBag = CancelBag()
        self.appState[\.userData.user].setIsLoading(cancelBag: cancelBag)
                
        GIDSignIn.sharedInstance.signIn(withPresenting: topViewController) { [weak self] result, error in
            guard error == nil else {
                self?.appState[\.userData.user].cancelLoading()
                return
            }
            
            guard let user = result?.user else {
                return
            }
            
            guard let idToken = user.idToken?.tokenString else{
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {res,err in
                
                guard error == nil else {
                    self?.appState[\.userData.user].cancelLoading()
                    return
                }
                
                Auth.auth().currentUser?.getIDToken(completion: { token, err in
                    guard error == nil else {
                        self?.appState[\.userData.user].cancelLoading()
                        return
                    }
                                                            
                    self?.authenticateWithServer(token)                   
                })
            }

        }
    }
    
    
    private func authenticateWithServer(_ authToken: String?) {
        let cancelBag = CancelBag()
        
        PersistentManager.instance.saveUserAuthToken(token: authToken ?? "")

        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                self.getUser()
            }
            .flatMap({ [self, userDBRepository] in
                loadSetting(cancelBag: cancelBag)
                return userDBRepository.loadUser()
            })
            .sink{ subscriptionCompletion in
                if let _ = subscriptionCompletion.error {
                    self.appState[\.userData.user] = .notRequested
                }
            } receiveValue: { user in
                PersistentManager.instance.saveUserCookieToken(token: user.token ?? "")
                self.appState[\.userData.user] = .loaded(user)
            }
            .store(in: cancelBag)
    }
    
    private func configureGID(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
}

// MARK: Helper Functions

extension MainAuthenticationService {
    private func register(name: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<Void, Error>{
        authenticateRepository
            .register(name: name, email: email, password: password, mobileNumber: mobileNumber)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository, settingDBRepository] in
                PersistentManager.instance.saveUserCookieToken(token: $0.data.user.token ?? "")
                _ = settingDBRepository.store(setting: $0.data.userSetting)
                _ = userDBRepository.store(user: $0.data.user)
            }
            .mapError{$0}
            .eraseToAnyPublisher()
    }
    
    private func login(email: String, password: String) -> AnyPublisher<Void, ServerError>{
        authenticateRepository
            .login(email: email, password: password)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository, settingDBRepository] in
                PersistentManager.instance.saveUserCookieToken(token: $0.data.user.token ?? "")
                _ = userDBRepository.store(user: $0.data.user)
                _ = settingDBRepository.store(setting: $0.data.userSetting)
            }
            .eraseToAnyPublisher()
    }
    
    private func loadSetting(cancelBag: CancelBag) {
        self.appState[\.userData.setting].setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap({ [settingDBRepository] in
                settingDBRepository.loadSetting()
            })
            .sinkToLoadable {
                self.appState[\.userData.setting] = $0
            }
            .store(in: cancelBag)
    }
    
    private func getUser() -> AnyPublisher<Void, Error>{
        authenticateRepository
            .getUserInfo()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository, settingDBRepository] in
                PersistentManager.instance.saveUserCookieToken(token: $0.data.user.token ?? "")
                _ = userDBRepository.store(user: $0.data.user)
                _ = settingDBRepository.store(setting: $0.data.userSetting)
            }
            .mapError{$0}
            .eraseToAnyPublisher()
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

// MARK: Stubs

struct StubAuthenticateService: AuthenticationService {
    func signInGoogle() {
    }
    
    func signOut() {
    }
    
    func checkUserStatus(loading: Binding<Bool>) {
    }
    
    func loginUser(email: String, password: String) {
    }
    
    func registerUser(name: String, email: String, password: String, mobileNumber: String){
    }
    
    func authenticateUserWithThirdParty(provider: Provider, token: String){
    }
}

enum Provider {
    case Google
    case Apple
}
