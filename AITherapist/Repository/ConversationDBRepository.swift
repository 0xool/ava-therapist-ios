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
    func loadConversations() -> AnyPublisher<[Conversation], Error>
}

struct MainConversationDBRepository: ConversationDBRepository {
    func hasLoadedConversation() -> AnyPublisher<Bool, Error> {
        return DataBaseManager.Instance.hasLoadedConversations()
    }
    
    func store(conversation: Conversation) -> AnyPublisher<Void, Error> {
        DataBaseManager.Instance.writeConversationData(conversation: conversation)
    }
    
    func loadConversations() -> AnyPublisher<[Conversation], Error> {
        DataBaseManager.Instance.readAllConversations()
    }
}
