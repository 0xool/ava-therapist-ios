//
//  ChatService.swift
//  AITherapist
//
//  Created by cyrus refahi on 10/12/23.
//


import Combine
import Foundation
import SwiftUI

protocol ChatService {
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int)
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    
    func saveChatInDB(chat: Chat)
}

struct MainChatService: ChatService {
    
    let chatRepository: ChatRepository
    let chatDBRepository: ChatDBRepository
    let appState: Store<AppState>
    
    init(chatRepository: ChatRepository, appState: Store<AppState>, chatDBRepository: ChatDBRepository) {
        self.chatRepository = chatRepository
        self.chatDBRepository = chatDBRepository
        self.appState = appState
    }
    
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int) {
        
        let cancelBag = CancelBag()
        chats.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        chatRepository
            .loadChatsForConversation(conversationID: conversationID)
            .map { [chatDBRepository] in
                for chat in $0 {
                    _ = chatDBRepository.store(chat: chat)
                }
                
                return $0
            }
            .sinkToLoadable { chats.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func saveChatInDB(chat: Chat) {
        _ = chatDBRepository.store(chat: chat)
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        return chatDBRepository.loadChatsBy(conversationID: conversationID)
    }
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>{
        return chatRepository.loadChatsForConversation(conversationID: conversationID)
    }

    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
    
}

struct StubChatService: ChatService {
    func saveChatInDB(chat: Chat) {
        
    }
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        return Just([].lazyList)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        return Just([].lazyList)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int) {
    }
}
