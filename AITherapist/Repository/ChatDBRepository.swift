//
//  ChatDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 10/10/23.
//

import Foundation
import RealmSwift
import Combine

protocol ChatDBRepository {
    func store(chat: Chat) -> AnyPublisher<Void, Error>
    func loadChats() -> AnyPublisher<LazyList<Chat>, Error>
    func loadChatsBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    func deletePreviousChat()
//    func loadConversationChat(id: Int) -> AnyPublisher<[Chat], Error>
}

struct MainChatDBRepository: ChatDBRepository {

    func store(chat: Chat) -> AnyPublisher<Void, Error>{
        writeChatData(chat: chat)
    }
    
    func loadChats() -> AnyPublisher<LazyList<Chat>, Error> {
        readAllChats()
    }
    
    func loadChatsBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        getChatBy(conversationID: conversationID)
    }

    func deletePreviousChat() {
        self.deleteLastChat()
    }
}

extension MainChatDBRepository {    
    private func getChatBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        DataBaseManager.Instance.GetByTypeID(ofType: Chat.self, id: conversationID) { $0.conversationID == conversationID }
            .map{ $0.lazyList }
            .eraseToAnyPublisher()
    }
    
    private func deleteLastChat() {
        DataBaseManager.Instance.DeleteLast(ofType: Chat.self)
    }
    
    private func readAllChats() -> AnyPublisher<LazyList<Chat>, Error> {
        let chats: LazyList<Chat> = DataBaseManager.Instance.GetAll()
        
        return Just(chats)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func writeChatData(chat: Chat) -> AnyPublisher<Void, Error> {
        return DataBaseManager.Instance.Write(writeData: chat)
    }
}

