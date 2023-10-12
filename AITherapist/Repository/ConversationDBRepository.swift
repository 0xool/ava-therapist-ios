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
}

extension MainConversationDBRepository {
    private func readAllConversations() -> AnyPublisher<LazyList<Conversation>, Error> {
        let conversations: LazyList<Conversation> = DataBaseManager.Instance.GetAll()
        
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
            return DataBaseManager.Instance.DeleteAndWrite(data: conversation)
                .eraseToAnyPublisher()
        }
    }
    
    private func hasLoadedConversations() -> AnyPublisher<Bool, Error> {
        let conversationCount = DataBaseManager.Instance.GetCount(value: Conversation.self)
        return Just(conversationCount > 0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
