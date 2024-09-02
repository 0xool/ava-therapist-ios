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

import AuthenticationServices
import CryptoKit
import CommonCrypto

protocol AuthenticationService {
    func loginUser(email: String, password: String)
    func registerUser(name: String, email: String, password: String, mobileNumber: String)
    func checkUserStatus(loading: Binding<Bool>)
    
    func authenticateUserWithThirdParty(provider: Provider, token: String)
    func signInGoogle()
    func handleSingInWithAppleRequest(request: ASAuthorizationAppleIDRequest)
    func handleSingInWithAppleCompletion(result: Result<ASAuthorization, Error>)
    func signOut()
}

class MainAuthenticationService: AuthenticationService {
    let authenticateRepository: AuthenticateWebRepository
    let userDBRepository: UserDBRepository
    let settingDBRepository: SettingDBRepository
    
    let appState: Store<AppState>
    private var currentNonce: String?
    
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

//        MARK: Sing In With Apple

extension MainAuthenticationService{
    
    func handleSingInWithAppleRequest(request: ASAuthorizationAppleIDRequest) {
        let cancelBag = CancelBag()
        
        self.appState[\.userData.user].setIsLoading(cancelBag: cancelBag)
        request.requestedScopes = [.email, .fullName]
        let nonce = randomNonceString()
        self.currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSingInWithAppleCompletion(result: Result<ASAuthorization, Error>){
        let cancelBag = CancelBag()
        
        if case .failure(let failure) = result {
            self.appState[\.userData.user].cancelLoading()
        }
        else if case .success(let success) = result {
            if let appleIdCredentials = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else{
                    self.appState[\.userData.user].cancelLoading()
                    fatalError("Invalid State: a login callback was recived, but no login request was sent")
                }
                
                guard let appleIDToken = appleIdCredentials.identityToken else{
                    self.appState[\.userData.user].cancelLoading()
                    return
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else{
                    self.appState[\.userData.user].cancelLoading()
                    return
                }
                
                let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
                
                Auth.auth().signIn(with: credential) {res,err in
                    
                    guard err == nil else {
                        self.appState[\.userData.user].cancelLoading()
                        return
                    }
                    
                    Auth.auth().currentUser?.getIDToken(completion: { token, err in
                        guard err == nil else {
                            self.appState[\.userData.user].cancelLoading()
                            return
                        }
                                                                
                        self.authenticateWithServer(token)
                    })
                }
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
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
                self?.appState[\.userData.user].cancelLoading()
                return
            }
            
            guard let idToken = user.idToken?.tokenString else{
                self?.appState[\.userData.user].cancelLoading()
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {res,err in
                
                guard err == nil else {
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
    func handleSingInWithAppleRequest(request: ASAuthorizationAppleIDRequest){}
    
    func handleSingInWithAppleCompletion(result: Result<ASAuthorization, Error>){}
        
    func signInGoogle() {}
    
    func signOut() {}
    
    func checkUserStatus(loading: Binding<Bool>) {}
    
    func loginUser(email: String, password: String) {}
    
    func registerUser(name: String, email: String, password: String, mobileNumber: String){}
    
    func authenticateUserWithThirdParty(provider: Provider, token: String){}
}

enum Provider {
    case Google
    case Apple
}
