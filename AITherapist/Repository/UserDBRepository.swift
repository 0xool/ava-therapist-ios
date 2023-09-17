//
//  UserDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/6/23.
//



import Foundation
import Combine

protocol UserDBRepository {
    func hasLoadedUser() -> AnyPublisher<Bool, Error>
    func store(user: User) -> AnyPublisher<Void, Error>
    func loadUser() -> AnyPublisher<User, Error>
}

struct MainUserDBRepository: UserDBRepository {
    
    func hasLoadedUser() -> AnyPublisher<Bool, Error> {
        DataBaseManager.Instance.hasLoadedUser()
    }
    
    func store(user: User) -> AnyPublisher<Void, Error> {
        DataBaseManager.Instance.writeUserData(user: user)
    }
    
    func loadUser() -> AnyPublisher<User, Error> {
        DataBaseManager.Instance.readUser()
    }
    
}
