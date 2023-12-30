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
    func registerUser(email: String, password: String, mobileNumber: String)
    func checkUserLoggedStatus()
}

class MainAuthenticationService: AuthenticationService {
    
    let authenticateRepository: AuthenticateWebRepository
    let userDBRepository: UserDBRepository
    let appState: Store<AppState>
    
    init(appState: Store<AppState>, authenticateRepository: AuthenticateWebRepository, userDBRepository: UserDBRepository){
        self.appState = appState
        self.authenticateRepository = authenticateRepository
        self.userDBRepository = userDBRepository
    }
    
    func checkUserLoggedStatus() {
        let cancelBag = CancelBag()
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap({ [userDBRepository] in
                userDBRepository.loadUser()
            })
            .sink{ subscriptionCompletion in
                if let _ = subscriptionCompletion.error {
                }
            } receiveValue: { user in
                self.authenticateRepository.SetCookie(cookie: user.token)
                self.appState[\.userData.user] = .loaded(user)
            }
            .store(in: cancelBag)
    }
    
    func loginUser(email: String, password: String) {
        
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
                    return self.login(email: email, password: password)
                }
            }
            .flatMap({ [userDBRepository] in
                userDBRepository.loadUser()
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
            .map { [userDBRepository] in
                _ = userDBRepository.store(user: $0)                
            }
            .eraseToAnyPublisher()
    }
                   
    func register(email: String, password: String, mobileNumber: String) -> AnyPublisher<Void, Error>{
        authenticateRepository
            .register(email: email, password: password, mobileNumber: mobileNumber)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository] in
                _ = userDBRepository.store(user: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func registerUser(email: String, password: String, mobileNumber: String){
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
                    return self.register(email: email, password: password, mobileNumber: mobileNumber)
                }
            }
            .flatMap({ [userDBRepository] in
                userDBRepository.loadUser()
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

struct StubAuthenticateService: AuthenticationService {
    func checkUserLoggedStatus() {
    }
    
    func loginUser(email: String, password: String) {
    }
    
    func registerUser(email: String, password: String, mobileNumber: String) {
    }
 }
