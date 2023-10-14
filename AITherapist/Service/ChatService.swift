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

    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
    
}

struct StubChatService: ChatService {
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int) {
    }
}
