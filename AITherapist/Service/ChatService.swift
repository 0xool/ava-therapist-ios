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
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, ServerError>
    
    func saveChatInDB(chat: Chat)
    func sendChatToServer(message: String, conversationID: Int) -> AnyPublisher<(Chat, Chat), ServerError>
    func deletePreviousUserMessage()
    func deleteAllChatFor(conversationID: Int)
    func sendChatToServer(chats: LoadableSubject<LazyList<Chat>>, message:String, conversationID: Int, isUserTurn: Binding<Bool>, cancelBag: CancelBag)
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
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, ServerError>{
        chatRepository.loadChatsForConversation(conversationID: conversationID)
            .map{
                $0.lazyList
            }
            .eraseToAnyPublisher()
    }

    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
    
    func sendChatToServer(message: String, conversationID: Int) -> AnyPublisher<(Chat, Chat), ServerError>{

        return chatRepository.sendChatToServer(data: .init(chat: .init(message: message, conversationID: conversationID)))
            .map{
                saveChatInDB(chat: $0)
                saveChatInDB(chat: $1)
                return ($0, $1)
            }
            .eraseToAnyPublisher()
    }
    
    func sendChatToServer(chats: LoadableSubject<LazyList<Chat>>, message:String, conversationID: Int, isUserTurn: Binding<Bool>, cancelBag: CancelBag){

        guard let chatValue = chats.wrappedValue.value else {
            return
        }
        
        var updatedChats = Array(chatValue)
        let serverChat: Chat = .init(id: updatedChats.last!.id + 1, message: "           ", conversationID: conversationID, chatSequence: nil, isUserMessage: false, isSentToserver: .LoadingServerChat)
        updatedChats.append(serverChat)
        chats.wrappedValue = .loaded(updatedChats.lazyList)

        chatRepository.sendChatToServer(data: .init(chat: .init(message: message, conversationID: conversationID)))
            .ensureTimeSpan(1)
            .sink { completion in
                switch completion {
                case .finished:
                    isUserTurn.wrappedValue = true
                    break
                    
                case .failure(_):
                    var newChat = Array(chatValue)
                    if let lastChat = newChat.last {
                        lastChat.chatState = .ErrorWhileSending
                        newChat.removeLast()
                        newChat.append(lastChat)
                        chats.wrappedValue = .loaded(newChat.lazyList)
                    }
                    break
                }
            } receiveValue: {
                saveChatInDB(chat: $0)
                saveChatInDB(chat: $1)
                
                var newChat = Array(chatValue)
                newChat.append(.init(id: $1.id, message: $1.message, conversationID: conversationID, chatSequence: $1.chatSequence, isUserMessage: false, isSentToserver: .LastServerChat))
                
                chats.wrappedValue = .loaded(newChat.lazyList)
            }
            .store(in: cancelBag)

    }
    
    func deletePreviousUserMessage() {
        _ = self.chatDBRepository.deletePreviousChat()
    }
}

struct StubChatService: ChatService {
    func sendChatToServer(message: String, conversationID: Int) -> AnyPublisher<(Chat, Chat), ServerError> {
        Just((Chat(), Chat()))
        .setFailureType(to: ServerError.self)
        .eraseToAnyPublisher()
    }
    
    func deletePreviousUserMessage() {
//        self.chatDBRepository.deletePreviousChat(
    }
    
    func deleteAllChatFor(conversationID: Int)  {
    }
    
    func saveChatInDB(chat: Chat) {
        
    }
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, ServerError> {
        Just([].lazyList)
        .setFailureType(to: ServerError.self)
        .eraseToAnyPublisher()
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        Just([].lazyList)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int) {
    }
    
    func sendChatToServer(chats: LoadableSubject<LazyList<Chat>>, message:String, conversationID: Int, isUserTurn: Binding<Bool>, cancelBag: CancelBag){
        
    }
}
