//
//  AuthenticateService.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/6/23.
//

import Foundation
import SwiftUI
import Combine

protocol AuthenticationService {
    func loginUser(email: String, password: String)
    func registerUser(nickname: String, email: String, password: String, mobileNumber: String)
    func checkUserLoggedStatus()
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
    }
    
    func checkUserLoggedStatus() {
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
                }
            } receiveValue: { user in
                PersistentManager.SaveUserToken(token: user.token)
                self.appState[\.userData.user] = .loaded(user)
            }
            .store(in: cancelBag)
    }
    
    func loginUser(email: String, password: String) {
        let cancelBag = CancelBag()
        self.appState[\.userData.user].setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                self.login(email: email, password: password)
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
    
    func login(email: String, password: String) -> AnyPublisher<Void, Error>{
        authenticateRepository
            .login(email: email, password: password)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository, settingDBRepository] in
                PersistentManager.SaveUserToken(token: $0.data.user.token)
                _ = userDBRepository.store(user: $0.data.user)
                _ = settingDBRepository.store(setting: $0.data.userSetting)
            }
            .eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<Void, Error>{
        authenticateRepository
            .getUserInfo()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository, settingDBRepository] in
                PersistentManager.SaveUserToken(token: $0.data.user.token)
                _ = userDBRepository.store(user: $0.data.user)
                _ = settingDBRepository.store(setting: $0.data.userSetting)
            }
            .eraseToAnyPublisher()
    }
    
    func loadSetting(cancelBag: CancelBag) {
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
    
    func registerUser(nickname: String, email: String, password: String, mobileNumber: String){
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
                    return self.register(nickname: nickname, email: email, password: password, mobileNumber: mobileNumber)
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
        
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

extension MainAuthenticationService {
    private func register(nickname: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<Void, Error>{
        authenticateRepository
            .register(nickname: nickname, email: email, password: password, mobileNumber: mobileNumber)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository, settingDBRepository] in
                PersistentManager.SaveUserToken(token: $0.data.user.token)
                _ = settingDBRepository.store(setting: $0.data.userSetting)
                _ = userDBRepository.store(user: $0.data.user)
            }
            .eraseToAnyPublisher()
    }
}

struct StubAuthenticateService: AuthenticationService {
    func checkUserLoggedStatus() {
    }
    
    func loginUser(email: String, password: String) {
    }
    
    func registerUser(nickname: String, email: String, password: String, mobileNumber: String){
    }
 }
