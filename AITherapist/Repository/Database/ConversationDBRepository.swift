//
//  ConversationDBRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/5/23.
//

import Foundation
import Combine

protocol ConversationDBRepository {
    func hasLoadedConversation() -> AnyPublisher<Bool, Error>
    func store(conversation: Conversation) -> AnyPublisher<Void, Error>
    func loadConversations() -> AnyPublisher<LazyList<Conversation>, Error>
    
    func addChatToConversation(chats: LazyList<Chat>) -> AnyPublisher<Void, Error>
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>
    func deleteAllConversation() -> AnyPublisher<Void, Error>
}

struct MainConversationDBRepository: ConversationDBRepository {
    
    let persistentStore: DataBase
    
    init(persistentStore: DataBase = DataBaseManager.Instance) {
        self.persistentStore = persistentStore
    }
    
    func hasLoadedConversation() -> AnyPublisher<Bool, Error> {
        hasLoadedConversations()
    }
    
    func store(conversation: Conversation) -> AnyPublisher<Void, Error> {
        writeConversationData(conversation: conversation)
    }
    
    func loadConversations() -> AnyPublisher<LazyList<Conversation>, Error> {
        readAllConversations()
    }
    
    func addChatToConversation(chats: LazyList<Chat>) -> AnyPublisher<Void, Error>{
        updateConversationChatsData(chats: chats)
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>{
        deleteConversationFromDBWith(id: conversationID)
            .eraseToAnyPublisher()
    }
    
    func deleteAllConversation() -> AnyPublisher<Void, Error> {
        persistentStore.DeleteAll(ofType: Conversation.self)
    }
}

extension MainConversationDBRepository {
    private func deleteConversationFromDBWith(id: Int) -> AnyPublisher<Void, Error>{
        persistentStore.DeleteByID(ofType: Conversation.self, id: id)
            .eraseToAnyPublisher()
    }
    
    private func readAllConversations() -> AnyPublisher<LazyList<Conversation>, Error> {
        let conversations: LazyList<Conversation> = persistentStore.GetAll().sorted(byKeyPath: "id", ascending: true)
            .lazyList
        
        return Just(conversations.sorted(by: { $0.dateCreated > $1.dateCreated }).lazyList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func conversationExist(id: Int) -> Bool {
        persistentStore.EntityExist(id: id, ofType: Conversation.self)
    }
    
    private func writeConversationData(conversation: Conversation) -> AnyPublisher<Void, Error> {
//        if !self.conversationExist(id: conversation.id)  {
            return persistentStore.Write(writeData: conversation)
                    .eraseToAnyPublisher()
//        }else{
//            return persistentStore.Update(value: conversation)
//                .eraseToAnyPublisher()
//        }
    }
    
    private func updateConversationChatsData(chats: LazyList<Chat>) -> AnyPublisher<Void, Error> {
        
        guard let conversationID = chats.first?.conversationID else {
            //return an Fail publisher
            #warning("Error is not correct")
            return Fail(error: DataBaseError.ObjcectWithIDNotFound).eraseToAnyPublisher()
        }
        
        guard let conversation: Conversation = persistentStore.GetByID(id: conversationID) else{
            return Fail(error: DataBaseError.ObjcectWithIDNotFound).eraseToAnyPublisher()
        }
                
        return persistentStore.Update(value: conversation)
            .eraseToAnyPublisher()
    }
    
    private func hasLoadedConversations() -> AnyPublisher<Bool, Error> {
        let conversationCount = persistentStore.GetCount(value: Conversation.self)
        return Just(conversationCount > 0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
