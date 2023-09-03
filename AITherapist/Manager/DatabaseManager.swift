//
//  DatabaseManager.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import Foundation
import RealmSwift

class DataBaseManager {
    
    static let Instance = DataBaseManager()
    let realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func writeConversationData(conversation: Conversation)  {
        let conversation = conversation
        
        if(!conversationExist(id: conversation.id)){
            realm.beginWrite()
            realm.add(conversation)
            try! realm.commitWrite()
        }else {
            realm.beginWrite()
            realm.delete(conversation)
            realm.add(conversation)
            try! realm.commitWrite()
        }
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


