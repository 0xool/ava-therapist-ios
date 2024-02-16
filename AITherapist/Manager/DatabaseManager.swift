//
//  DatabaseManager.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import Foundation
import RealmSwift
import Combine

protocol DataBase {
    func GetAll<T: Object>() -> Results<T>
    func GetByID<T: Object>(id: Int) -> T?
    func GetLast<T: Object>(ofType: T.Type) -> T?
    
    func GetByTypeID<T: Object>(ofType: T.Type, id: Int, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error>
    func GetByQuery<T: Object>(ofType: T.Type, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error>
    func GetCount<T: Object>(value: T.Type) -> Int
    
    func Write<T: Object>(writeData: T) -> AnyPublisher<Void, Error>
    func Update<T: Object>(value: T) -> AnyPublisher<Void,  Error>
    func Update(changeValue: @escaping () -> ()) -> AnyPublisher<Void,  Error>
    
    func EntityExist<Element: Object>(id: Int, ofType: Element.Type) -> Bool    
    func DeleteLast<T: Object>(ofType: T.Type) -> AnyPublisher<Void,  Error>
    func DeleteAll<T: Object>(ofType: T.Type) -> AnyPublisher<Void,  Error>
    
    func DeleteByID<T: Object>(ofType: T.Type, id: Int) -> AnyPublisher<Void,  Error>
    func DeleteByQuery<T: Object>(ofType: T.Type, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Void,  Error>
    func ClearAllData()
}

class DataBaseManager: DataBase {
    
    static let Instance = DataBaseManager()
    private var realm: Realm
    private var cancellable: AnyCancellable?
    
    init() {
        realm = try! Realm()
    }
    
    func setRealm(realm: Realm) {
        self.realm = realm
    }
    
    func getDB() -> Realm {
        return realm
    }
    
    func GetAll<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func DeleteLast<T: Object>(ofType: T.Type) -> AnyPublisher<Void,  Error> {
        guard let last = realm.objects(T.self).last else{
            return Fail<Void, Error>(error: DataBaseError.NotFound).eraseToAnyPublisher()
        }
        
        return Future<Void, Error> { promise in
            do {
                try self.realm.write {
                    self.realm.delete(last)
                }
                
                promise(.success(()))
            } catch {
                promise(.failure(DataBaseError.ErrorWhileDeleting))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func DeleteAll<T: Object>(ofType: T.Type) -> AnyPublisher<Void,  Error>{
        return Future<Void, Error> { promise in
            do {
                try self.realm.write {
                    self.realm.delete(self.realm.objects(T.self))
                }
                
                promise(.success(()))
            } catch {
                promise(.failure(DataBaseError.ErrorWhileDeleting))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func ClearAllData() {
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        }catch {
            
        }
    }
    
    func DeleteByQuery<T: Object>(ofType: T.Type, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Void,  Error> {
        let value: Results<T> = self.realm.objects(T.self).where(query)
        
        return Future<Void, Error> { promise in
            
            do {
                try self.realm.write {
                    self.realm.delete(value)
                }
                
                promise(.success(()))
            } catch {
                promise(.failure(DataBaseError.ErrorWhileDeleting))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func DeleteByID<T: Object>(ofType: T.Type, id: Int) -> AnyPublisher<Void, Error> {
        guard let entity = realm.object(ofType: T.self, forPrimaryKey: id) else{
            return Fail<Void, Error>(error: DataBaseError.NotFound)
                .eraseToAnyPublisher()
        }
        
        return Future<Void, Error> { promise in
            do {
                try self.realm.write {
                    self.realm.delete(entity)
                }
                
                promise(.success(()))
            } catch {
                promise(.failure(DataBaseError.ErrorWhileDeleting))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func GetByTypeID<T: Object>(ofType: T.Type, id: Int, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error> {
        return Future<Results<T>, Error> { promise in
            let value: Results<T> = self.realm.objects(T.self) .where(query)
#warning("FIX!!!")
            //            if (value.count <= 0){
            promise(.success(value))
            //            }else{
            //                promise(.failure(DataBaseError.NotFound))
            //            }
        }
        .eraseToAnyPublisher()
    }
    
    func GetByQuery<T: Object>(ofType: T.Type, query: @escaping (Query<T>) -> Query<Bool>) -> AnyPublisher<Results<T>, Error> {
        
        Future<Results<T>, Error> { promise in
            let value: Results<T> = self.realm.objects(T.self) .where(query)
#warning("FIX!!!")
            //            if (value.count <= 0){
            promise(.success(value))
            //            }else{
            //                promise(.failure(DataBaseError.NotFound))
            //            }
        }
        .eraseToAnyPublisher()
    }
    
    func IncrementaChatID() -> Int{
        if let retNext = realm.objects(Chat.self).sorted(byKeyPath: "id", ascending: false).first?.id {
            return retNext + 1
        }else{
            return 1
        }
    }
    
    func GetByID<T: Object>(id: Int) -> T? {
        realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func GetLast<T: Object>(ofType: T.Type) -> T?{
        realm.objects(T.self).last
    }
    
    func GetCount<T: Object>(value: T.Type) -> Int {
        realm.objects(T.self).lazyList.count
    }
    
    func EntityExist<Element: Object>(id: Int, ofType: Element.Type) -> Bool{
        realm.object(ofType: ofType, forPrimaryKey: id) != nil
    }
    
    func Update<T: Object>(value: T) -> AnyPublisher<Void,  Error> {
        return Future<Void, Error> { promise in
            do {
                try self.realm.write {
                    self.realm.add(value, update: .modified)
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func Update(changeValue: @escaping () -> ()) -> AnyPublisher<Void,  Error> {
        return Future<Void, Error> { promise in
            do {
                try self.realm.write {
                    changeValue()
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func Write<T: Object>(writeData: T) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> {  promise in
            do {
                try self.realm.write {
                    self.realm.add(writeData, update: .all)
                }
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

public enum DataBaseError: Error {
    case SelfIsNil
    case UserIsNil
    case ObjcectWithIDNotFound
    case NotFound
    case ErrorWhileDeleting
}
