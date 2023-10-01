//
//  AuthenticateService.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/6/23.
//

import Foundation
import SwiftUI
import Combine

protocol AuthenticateService {
    func loginUser(email: String, password: String)
    func registerUser(auth: LoadableSubject<User>, email: String, password: String)
    func checkUserLoggedStatus()
}

class MainAuthenticateService: AuthenticateService {
    
    let authenticateRepository: AuthenticateRepository
    let userDBRepository: UserDBRepository
    let appState: Store<AppState>
    
    init(appState: Store<AppState>, authenticateRepository: AuthenticateRepository, userDBRepository: UserDBRepository){
        self.appState = appState
        self.authenticateRepository = authenticateRepository
        self.userDBRepository = userDBRepository
    }
    
    //    func loadConversationList(conversations: LoadableSubject<[Conversation]>) {
    //
    //        let cancelBag = CancelBag()
    //        conversations.wrappedValue.setIsLoading(cancelBag: cancelBag)
    //
    //        Just<Void>
    //            .withErrorType(Error.self)
    //            .flatMap { [conversationDBRepository] _ -> AnyPublisher<Bool, Error> in
    //                conversationDBRepository.hasLoadedConversation()
    //            }
    //            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
    //                if hasLoaded {
    //                    return Just<Void>.withErrorType(Error.self)
    //                } else {
    //                    return self.refreshConversationList()
    //                }
    //            }
    //            .flatMap({ [conversationDBRepository] in
    //                conversationDBRepository.loadConversations()
    //            })
    //            .sinkToLoadable { conversations.wrappedValue = $0 }
    //            .store(in: cancelBag)
    //    }
    
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
        return authenticateRepository
            .login(email: email, password: password)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [userDBRepository] in
                _ = userDBRepository.store(user: $0)                
            }
            .eraseToAnyPublisher()
    }
                   
    func registerUser(auth: LoadableSubject<User>, email: String, password: String) {
        
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

struct StubAuthenticateService: AuthenticateService {
    func checkUserLoggedStatus() {
    }
    
    func loginUser(email: String, password: String) {
    }
    
    func registerUser(auth: LoadableSubject<User>, email: String, password: String) {
    }
 }
