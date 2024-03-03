//
//  ChatDBRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 10/10/23.
//

import Foundation
import RealmSwift
import Combine

protocol ChatDBRepository {
    func store(chat: Chat) -> AnyPublisher<Void, Error>
    func loadChats() -> AnyPublisher<LazyList<Chat>, Error>
    func loadChatsBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    
    func deletePreviousChat() -> AnyPublisher<Void, Error>
    func deleteAllPreviousChatsFor(conversationID: Int) -> AnyPublisher<Void, Error>
//    func loadConversationChat(id: Int) -> AnyPublisher<[Chat], Error>
}

struct MainChatDBRepository: ChatDBRepository {
    
    let persistentStore: DataBase
    
    init(persistentStore: DataBase = DataBaseManager.Instance) {
        self.persistentStore = persistentStore
    }

    func store(chat: Chat) -> AnyPublisher<Void, Error>{
        writeChatData(chat: chat)
    }
    
    func loadChats() -> AnyPublisher<LazyList<Chat>, Error> {
        readAllChats()
    }
    
    func loadChatsBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        getChatBy(conversationID: conversationID)
    }

    func deletePreviousChat() -> AnyPublisher<Void, Error> {
        self.deleteLastChat()
    }
    
    func deleteAllPreviousChatsFor(conversationID: Int) -> AnyPublisher<Void, Error>{
        self.deleteChatFor(conversationID: conversationID)
    }
}

extension MainChatDBRepository {    
    private func getChatBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {        
        persistentStore.GetByTypeID(ofType: Chat.self, id: conversationID) { $0.conversationID == conversationID }
            .map{ $0.lazyList }
            .eraseToAnyPublisher()
    }
    
    private func deleteLastChat() -> AnyPublisher<Void, Error> {
        persistentStore.DeleteLast(ofType: Chat.self)
    }
    
    private func deleteChatFor(conversationID: Int) -> AnyPublisher<Void, Error> {
        persistentStore.DeleteByQuery(ofType: Chat.self) { $0.conversationID == conversationID }
    }
    
    private func readAllChats() -> AnyPublisher<LazyList<Chat>, Error> {
        let chats: LazyList<Chat> = persistentStore.GetAll().lazyList
        
        return Just(chats)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func writeChatData(chat: Chat) -> AnyPublisher<Void, Error> {
        persistentStore.Write(writeData: chat)
    }
}

