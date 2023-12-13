//
//  MockedPersistentStore.swift
//  UnitTests
//
//  Created by Cyrus Refahi on 10/6/23.
//  Copyright © 2020 Cyrus Refahi. All rights reserved.
//

import RealmSwift
import Combine
@testable import AITherapist

final class MockedPersistentStore: Mock, DataBase {
//    private let realm: Realm
    enum DataBaseAction: Equatable {
        case getAll
        case getByID(Int)
        case getLast
        case getByTypeID(Int)
        case getByQuery
        case getCount
        case write
        case update
        case entityExist(Int)
        case deleteLast
        case deleteByID(Int)
    }
    typealias Action = DataBaseAction
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        actions = MockActions(expected: expected)
    }
    
    func GetAll<T: Object>() -> Results<T> {
        register(.getAll)
        
        // return a mock result which is a RealmSwift.Results
        return try! Realm(configuration:  Realm.Configuration(inMemoryIdentifier: "test")).objects(T.self)
    }
    
    func GetByID<T: Object>(id: Int) -> T? {
        register(.getByID(id))
        return nil
    }
    
    func GetLast<T: Object>(ofType: T.Type) -> T? {
        register(.getLast)
        // Return a mock result
        return nil
    }
    
    func GetByTypeID<T: Object>(ofType: T.Type, id: Int, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error> {
        register(.getByTypeID(id))
        // Return a mock result
        return Future { promise in
//            promise(.success(Results<T>()))
        }.eraseToAnyPublisher()
    }
    
    func GetByQuery<T: Object>(ofType: T.Type, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error> {
        register(.getByQuery)
        // Return a mock result
        return Future { promise in
//            promise(.success(Results<T>()))
        }.eraseToAnyPublisher()
    }
    
    func GetCount<T: Object>(value: T.Type) -> Int {
        register(.getCount)
        // Return a mock result
        return 0
    }
    
    func Write<T: Object>(writeData: T) -> AnyPublisher<Void, Error> {
        register(.write)
        // Return a mock result
        return Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    func Update<T: Object>(value: T) -> AnyPublisher<Void,  Error> {
        register(.update)
        return Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    func EntityExist<Element: Object>(id: Int, ofType: Element.Type) -> Bool {
        register(.entityExist(id))
        return true
    }
    
    func DeleteLast<T: Object>(ofType: T.Type) {
        register(.deleteLast)
    }
    
    func DeleteByID<T: Object>(ofType: T.Type, id: Int) -> AnyPublisher<Void,  Error> {
        register(.deleteByID(id))
        // Return a mock result
        return Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}

