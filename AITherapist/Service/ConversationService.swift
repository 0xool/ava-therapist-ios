//
//  ConversationService.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/4/23.
//

import Combine
import Foundation
import RealmSwift

protocol ConversationService {
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>)
    func loadConversationChat(conversation: LoadableSubject<Conversation>)
    func createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String)
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>
}

struct MainConversationService: ConversationService {
    
    let conversationRepository: ConversationRepository
    let conversationDBRepository: ConversationDBRepository
    let chatService: ChatService
    
    let appState: Store<AppState>
    
    init(conversationRepository: ConversationRepository, appState: Store<AppState>, conversationDBRepository: ConversationDBRepository, chatService: ChatService) {
        self.conversationRepository = conversationRepository
        self.conversationDBRepository = conversationDBRepository
        self.chatService = chatService
        self.appState = appState
    }
    
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>) {
        
        let cancelBag = CancelBag()
        conversations.wrappedValue.setIsLoading(cancelBag: cancelBag)
  
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { _ -> AnyPublisher<Void, Error> in
                self.refreshConversationList()
            }
            .flatMap({ [conversationDBRepository] in
                conversationDBRepository.loadConversations()
            })
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .sinkToLoadable { conversations.wrappedValue = $0 }
            .store(in: cancelBag)
        
//        self.refreshConversationList()
//            .sinkToResult { _ in
//                self.conversationDBRepository.loadConversations()
//                    .sinkToLoadable { conversations.wrappedValue = $0 }
//                    .store(in: cancelBag)
//            }
//            .store(in: cancelBag)
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error> {
        return conversationRepository.deleteConversation(conversationID: conversationID)
            .eraseToAnyPublisher()
    }
    
    func loadConversationChat(conversation: LoadableSubject<Conversation>){
        let cancelBag = CancelBag()
        conversation.wrappedValue.setIsLoading(cancelBag: cancelBag)
        guard let id = conversation.wrappedValue.value?.id else {
            return Just<Void>
                .withErrorType(Error.self)
                .sinkToLoadable{ _ in conversation.wrappedValue = .failed(Error.self as! Error)}
                .store(in: cancelBag)
        }
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                self.loadConversationChatFromWeb(conversationID: id)
            }
            .map { [chatService] in
                chatService.loadChatFromDBBy(conversationID: id)
            }
            .flatMap{ publisher in
                convertLazyListChatToConversation(publisher: publisher, conversation: conversation)
            }
            .sinkToLoadable { conversation.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func loadConversationChatFromWeb(conversationID: Int) -> AnyPublisher<Void, Error> {
        return chatService
            .getChatsForConversationFromServer(conversationID: conversationID)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map{ [chatService] in
                for chat in $0 {
                    chatService.saveChatInDB(chat: chat)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String = "New Conversation"){
        let cancelBag = CancelBag()
        conversation.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        conversationRepository.addConversation(data: .init(conversation: .init(conversationName: conversationName)))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    conversation.wrappedValue = .failed(error)
                case .finished:
                    // Handle the successful completion
                    break
                }
            } receiveValue: {
                var conversations : [Conversation] = appState[\.conversationData.conversations].value!.map {$0}
                conversations.append($0)
                
                appState[\.conversationData.conversations] = .loaded(conversations.lazyList)
                 conversation.wrappedValue = .loaded($0)
            }
            .store(in: cancelBag)
    }
    
    private func convertLazyListChatToConversation(publisher: AnyPublisher<LazyList<Chat>, Error>,  conversation: LoadableSubject<Conversation>) -> AnyPublisher<Conversation, Error> {
        return publisher
            .map{
                convertLazyListChatToList(chats: $0)
            }
            .map{
                let conversation = Conversation(id: conversation.wrappedValue.value!.id, conversationName: conversation.wrappedValue.value!.conversationName, date: conversation.wrappedValue.value!.dateCreated)
                for chat in $0.lazyList {
                    conversation.chats.append(chat)
                }
                
                return conversation
            }
            .eraseToAnyPublisher()
    }
    
    private func convertLazyListChatToList(chats: LazyList<Chat>) -> List<Chat> {
        let chat: List<Chat> = List()
        for c in chats {
            chat.append(c)
        }
        
        return chat
    }
    
    func refreshConversationList() -> AnyPublisher<Void, Error> {
        return conversationRepository
            .loadConversationList()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [conversationDBRepository] in
                appState[\.conversationData.conversations] = .loaded($0.lazyList)
                for conversation in $0 {
                    _ = conversationDBRepository.store(conversation: conversation)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 1
    }
}

extension MainConversationService{
    private func getLastConversation() -> Conversation? {
        DataBaseManager.Instance.GetLast(ofType: Conversation.self)
    }
}

struct StubConversationService: ConversationService {
    func createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String) {
        
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error> {
        return Just<Void>.withErrorType(Error.self)
    }
    
    func createNewConversation() -> AnyPublisher<Void, Error> {
        return Just<Void>.withErrorType(Error.self)
    }
    
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>) {
        let cancelBag = CancelBag()
        conversations.wrappedValue.setIsLoading(cancelBag: cancelBag)
        let convos = [
            Conversation(id: 1, conversationName: "Conversation 1", date: .now),
            Conversation(id: 2, conversationName: "Conversation 1", date: .now + 1),
            Conversation(id: 3, conversationName: "Conversation 1", date: .now + 2),
            Conversation(id: 4, conversationName: "Conversation 1", date: .now + 3)
        ].lazyList
        
        conversations.wrappedValue = .loaded(convos)
    }
    
    func loadConversationChat(conversation: LoadableSubject<Conversation>) {
    }
}
