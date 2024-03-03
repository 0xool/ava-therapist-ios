//
//  UserDBRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/6/23.
//

import Foundation
import Combine

protocol UserDBRepository {
    func hasLoadedUser() -> AnyPublisher<Bool, Error>
    func store(user: User) -> AnyPublisher<Void, Error>
    func updateUser(user: User) -> AnyPublisher<Void, Error>
    
    func loadUser() -> AnyPublisher<User, Error>
    func deleteUser() -> AnyPublisher<Void, Error>
    func changeValue(_ change: @escaping () -> ()) -> AnyPublisher<Void, Error>
}

struct MainUserDBRepository: UserDBRepository {
    let persistentStore: DataBase
    
    init(persistentStore: DataBase = DataBaseManager.Instance) {
        self.persistentStore = persistentStore
    }
    
    func hasLoadedUser() -> AnyPublisher<Bool, Error> {
        self.getUserCountFromDB()
    }
    
    func store(user: User) -> AnyPublisher<Void, Error> {
        self.storeUserToDB(user: user)
    }
    
    func updateUser(user: User) -> AnyPublisher<Void, Error>{
        self.updateUserInDB(user: user)
    }
    
    func loadUser() -> AnyPublisher<User, Error> {
        self.loadUsertFromDB()
    }
    
    func deleteUser() -> AnyPublisher<Void, Error> {
        self.deleteUserFromDB()
    }
    
    func changeValue(_ change: @escaping () -> ()) -> AnyPublisher<Void, Error> {
        persistentStore.Update(changeValue: change)
    }
}

extension MainUserDBRepository {
    private func deleteUserFromDB() -> AnyPublisher<Void, Error> {
        persistentStore.DeleteLast(ofType: User.self)
    }
    
    private func updateUserInDB(user: User) -> AnyPublisher<Void, Error>{
        persistentStore.Update(value: user)
    }
    
    private func loadUsertFromDB() -> AnyPublisher<User, Error>{
        guard let user = persistentStore.GetLast(ofType: User.self) else{
            return Fail(error: DataBaseError.NotFound)
                .eraseToAnyPublisher()
        }
        
        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func storeUserToDB(user: User) -> AnyPublisher<Void, Error>{
        _ = persistentStore.DeleteLast(ofType: User.self)
        return persistentStore.Write(writeData: user)
    }
    
    private func getUserCountFromDB() -> AnyPublisher<Bool, Error> {
        let userCount = persistentStore.GetCount(value: User.self)
        
        return Just(userCount > 0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
