//
//  ConversationDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/5/23.
//

import Foundation
import Combine

protocol ConversationDBRepository {
    func hasLoadedConversation() -> AnyPublisher<Bool, Error>
    func store(conversation: Conversation) -> AnyPublisher<Void, Error>
    func loadConversations() -> AnyPublisher<LazyList<Conversation>, Error>
    
    func addChatToConversation(chats: LazyList<Chat>) -> AnyPublisher<Void, Error>
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>
}

struct MainConversationDBRepository: ConversationDBRepository {
    func hasLoadedConversation() -> AnyPublisher<Bool, Error> {
        return hasLoadedConversations()
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
    }
}

extension MainConversationDBRepository {
    private func deleteConversationFromDBWith(id: Int) -> AnyPublisher<Void, Error>{
        DataBaseManager.Instance.DeleteByID(ofType: Conversation.self, id: id)
        
        return Just<Void>
            .withErrorType(Error.self)
            .eraseToAnyPublisher()
    }
    
    private func readAllConversations() -> AnyPublisher<LazyList<Conversation>, Error> {
        let conversations: LazyList<Conversation> = DataBaseManager.Instance.GetAll().sorted(byKeyPath: "id", ascending: false)
            .lazyList

        
        return Just(conversations)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func conversationExist(id: Int) -> Bool {
        return DataBaseManager.Instance.EntityExist(id: id, ofType: Conversation.self)
    }
    
    private func writeConversationData(conversation: Conversation) -> AnyPublisher<Void, Error> {
        if !self.conversationExist(id: conversation.id)  {
            return DataBaseManager.Instance.Write(writeData: conversation)
                    .eraseToAnyPublisher()
        }else{
            return DataBaseManager.Instance.Update(value: conversation)
                .eraseToAnyPublisher()
        }
    }
    
    private func updateConversationChatsData(chats: LazyList<Chat>) -> AnyPublisher<Void, Error> {
        
        guard let conversationID = chats.first?.conversationID else {
            //return an Fail publisher
            #warning("Error is not correct")
            return Fail(error: DataBaseError.ObjcectWithIDNotFound).eraseToAnyPublisher()
        }
        
        guard let conversation = DataBaseManager.Instance.GetByID(id: conversationID) else{
            return Fail(error: DataBaseError.ObjcectWithIDNotFound).eraseToAnyPublisher()
        }
                
        return DataBaseManager.Instance.Update(value: conversation)
            .eraseToAnyPublisher()
    }
    
    private func hasLoadedConversations() -> AnyPublisher<Bool, Error> {
        let conversationCount = DataBaseManager.Instance.GetCount(value: Conversation.self)
        return Just(conversationCount > 0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
