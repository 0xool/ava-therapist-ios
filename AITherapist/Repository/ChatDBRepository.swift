//
//  ChatDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 10/10/23.
//

import Foundation
import Combine

protocol ChatDBRepository {
//    func store(conversation: Conversation) -> AnyPublisher<Void, Error>
//    func loadConversationChat(id: Int) -> AnyPublisher<[Chat], Error>
}

struct MainChatDBRepository: ChatDBRepository {
    let db = DataBaseManager.Instance.getDB()
//    func store(conversation: Conversation) -> AnyPublisher<Void, Error> {
//        DataBaseManager.Instance.writeConversationData(conversation: conversation)
//    }
    
//    func loadConversationChat(id: Int) -> AnyPublisher<[Chat], Error> {
//        DataBaseManager.Instance.readAllConversations()
        
//    }
}

extension MainChatDBRepository {
//    private func getChatsByConversationID(id: Int) -> [Chat] {
//        let chats = db.objects(Chat.self)
//        let conversationChat = chats.where{
//            $0.conversationID == id
//        }
//
//    }
}

