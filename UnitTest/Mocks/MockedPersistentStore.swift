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

final class MockedPersistentStore: DataBaseManager, Mock {
    
    typealias Action = DataBaseAction
    private let realm: Realm
    
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
    
    var actions = MockActions<Action>(expected: [])

    override init() {
        realm = try! Realm(configuration:  Realm.Configuration(inMemoryIdentifier: "test"))
    }

    override func GetAll<T: Object>() -> Results<T> {
        register(.getAll)
        return super.GetAll()
    }
    
    override func GetByID<T: Object>(id: Int) -> T? {
        register(.getByID(id))
        return super.GetByID(id: id)
    }
    
    override func GetLast<T: Object>(ofType: T.Type) -> T? {
        register(.getLast)
        return super.GetLast(ofType: ofType)
    }
    
    override func GetByTypeID<T: Object>(ofType: T.Type, id: Int, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error> {
        register(.getByTypeID(id))
        return super.GetByTypeID(ofType: ofType, id: id, query: query)
    }
    
    override func GetByQuery<T: Object>(ofType: T.Type, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error> {
        register(.getByQuery)
        return super.GetByQuery(ofType: ofType, query: query)
    }
    
    override func GetCount<T: Object>(value: T.Type) -> Int {
        register(.getCount)
        return super.GetCount(value: value)
    }
    
    override func Write<T: Object>(writeData: T) -> AnyPublisher<Void, Error> {
        register(.write)
        return super.Write(writeData: writeData)
    }
    
    override func Update<T: Object>(value: T) -> AnyPublisher<Void,  Error> {
        register(.update)
        return Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    override func EntityExist<Element: Object>(id: Int, ofType: Element.Type) -> Bool {
        register(.entityExist(id))
        return true
    }
    
    override func DeleteLast<T: Object>(ofType: T.Type) -> AnyPublisher<Void,  Error> {
        register(.deleteLast)
        return Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    override func DeleteByID<T: Object>(ofType: T.Type, id: Int) -> AnyPublisher<Void,  Error> {
        register(.deleteByID(id))
        return Future { promise in
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    func preLoadData(data: [Object]) {
        try! realm.write {
            realm.add(data)
        }
    }

    func removeAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

