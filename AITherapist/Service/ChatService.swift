//
//  ChatService.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 10/12/23.
//


import Combine
import Foundation
import SwiftUI

protocol ChatService {
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int)
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    
    func saveChatInDB(chat: Chat)
    func sendChatToServer(message: String, conversationID: Int) -> AnyPublisher<(Chat, Chat), Error>
    func deletePreviousUserMessage()
    func deleteAllChatFor(conversationID: Int)
}

struct MainChatService: ChatService {
    
    let chatRepository: ChatWebRepository
    let chatDBRepository: ChatDBRepository
    let appState: Store<AppState>
    
    init(chatRepository: ChatWebRepository, appState: Store<AppState>, chatDBRepository: ChatDBRepository) {
        self.chatRepository = chatRepository
        self.chatDBRepository = chatDBRepository
        self.appState = appState
    }
    
    func deleteAllChatFor(conversationID: Int){
        _ = self.chatDBRepository.deleteAllPreviousChatsFor(conversationID: conversationID)
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
                
                return $0.lazyList
            }
            .sinkToLoadable { chats.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func saveChatInDB(chat: Chat) {
        _ = chatDBRepository.store(chat: chat)
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        return chatDBRepository.loadChatsBy(conversationID: conversationID)            
            .eraseToAnyPublisher()
    }
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>{
        chatRepository.loadChatsForConversation(conversationID: conversationID)
            .map{
                $0.lazyList
            }
            .eraseToAnyPublisher()
    }

    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
    
    func sendChatToServer(message: String, conversationID: Int) -> AnyPublisher<(Chat, Chat), Error>{

        return chatRepository.sendChatToServer(data: .init(chat: .init(message: message, conversationID: conversationID)))
            .map{
                saveChatInDB(chat: $0)
                saveChatInDB(chat: $1)                
                return ($0, $1)
            }
            .eraseToAnyPublisher()
    }
    
    func deletePreviousUserMessage() {
        _ = self.chatDBRepository.deletePreviousChat()
    }
}

struct StubChatService: ChatService {
    func sendChatToServer(message: String, conversationID: Int) -> AnyPublisher<(Chat, Chat), Error> {
        Just((Chat(), Chat()))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func deletePreviousUserMessage() {
//        self.chatDBRepository.deletePreviousChat(
    }
    
    func deleteAllChatFor(conversationID: Int)  {
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
