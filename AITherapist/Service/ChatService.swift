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
    func sendChatToServer(message: String, conversation: Conversation) -> AnyPublisher<Chat, Error>
    func deletePreviousUserMessage()
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
    
    func sendChatToServer(message: String, conversation: Conversation) -> AnyPublisher<Chat, Error>{
    
        let userChat = Chat(message: message, conversationID: conversation.id, chatSequence: nil, isUserMessage: true, isSentToserver: .NoStatus)

        return chatRepository.sendChatToServer(data: .init(chat: .init(message: message, conversationID: conversation.id)))
            .map{
                userChat.isSentToServer = .NoStatus
                _ = chatDBRepository.store(chat: userChat)
                saveChatInDB(chat: $0)
                
                return $0
            }
            .mapError{
                userChat.isSentToServer = .ErrorWhileSending
                _ = chatDBRepository.store(chat: userChat)
                
                return $0
            }
            .eraseToAnyPublisher()
    }
    
    func deletePreviousUserMessage() {
        self.chatDBRepository.deletePreviousChat()
    }
}

struct StubChatService: ChatService {
    func sendChatToServer(message: String, conversation: Conversation) -> AnyPublisher<Chat, Error> {
        Just(Chat())
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func deletePreviousUserMessage() {
//        self.chatDBRepository.deletePreviousChat(
    }
    
    func saveChatInDB(chat: Chat) {
        
    }
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        Just([].lazyList)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        Just([].lazyList)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int) {
    }
}
