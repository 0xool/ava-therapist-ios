//
//  DatabaseManager.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import Foundation
import RealmSwift
import Combine

class DataBaseManager {
    
    static let Instance = DataBaseManager()
    let realm: Realm
    private var cancellable: AnyCancellable?

    
    init() {
        realm = try! Realm()
    }
    
    func hasLoadedConversations() -> AnyPublisher<Bool, Error> {
        let countryCount = realm.objects(Conversation.self).count
        return Just(countryCount > 0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func readAllConversations() -> AnyPublisher<[Conversation], Error> {
        let conversations = Array(realm.objects(Conversation.self))
        
        return Just(conversations)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func writeConversationData(conversation: Conversation) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
               guard let self = self else {
                   promise(.failure(MyError.selfIsNil))
                   return
               }
               
               if !self.conversationExist(id: conversation.id)  {
                   do {
                       try self.realm.write {
                           self.realm.add(conversation)
                       }
                       promise(.success(()))
                   } catch {
                       promise(.failure(error))
                   }
               } else {
                   do {
                       try self.realm.write {
                           self.realm.delete(conversation)
                           self.realm.add(conversation)
                       }
                       promise(.success(()))
                   } catch {
                       promise(.failure(error))
                   }
               }
           }
           .eraseToAnyPublisher()
        //        let conversation = conversation
//
//        if(!conversationExist(id: conversation.id)){
//            realm.beginWrite()
//            realm.add(conversation)
//            try! realm.commitWrite()
//        }else {
//            realm.beginWrite()
//            realm.delete(conversation)
//            realm.add(conversation)
//            try! realm.commitWrite()
//        }
    }
//
    func readRecipeDatas() -> Conversation{
        return Array(realm.objects(Conversation.self))[0]
    }
//
    func deleteConversation(conversation: Conversation) {
        realm.delete(conversation)
    }
//
//    func deleteRecipeDataByID(favRecipeID: Int) {
//        if(favRecipeExist(id: favRecipeID)){
//            try! realm.write {
//                let favRecipe = realm.objects(FavRecipe.self).where {
//                    $0.id == favRecipeID
//                }
//                realm.delete(favRecipe)
//            }
//        }
//    }

    private func conversationExist(id: Int) -> Bool {
        return realm.object(ofType: Conversation.self, forPrimaryKey: id) != nil
    }
    
}

extension DataBaseManager {
    enum MyError: Error {
        case selfIsNil
    }
}

