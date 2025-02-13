//
//  ConversationService.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/4/23.
//

import Combine
import Foundation
import RealmSwift

protocol ConversationService {
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>)
    func loadConversationChat(conversation: LoadableSubject<Conversation>, conversationID: Int)
    func createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String)
    
    func deleteConversation(conversationID: Int)
    func loadConversationChat(conversation: LoadableSubject<LazyList<Chat>>, conversationID: Int)
    func deleteConversationAndUpdate(conversationID: Int)
    
    func addConversationToDB(conversation: Conversation)
    func loadConversationList()
}

struct MainConversationService: ConversationService {
    let conversationRepository: ConversationWebRepository
    let conversationDBRepository: ConversationDBRepository
    let chatService: ChatService
    
    let appState: Store<AppState>
    
    init(conversationRepository: ConversationWebRepository, appState: Store<AppState>, conversationDBRepository: ConversationDBRepository, chatService: ChatService) {
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
    }
    
    func loadConversationList() {
        
        let cancelBag = CancelBag()

        self.appState[\.conversationData.conversations].setIsLoading(cancelBag: cancelBag)
  
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { _ -> AnyPublisher<Void, Error> in
                self.refreshConversationList()
            }
            .flatMap({ [conversationDBRepository] in
                conversationDBRepository.loadConversations()
            })
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .sinkToLoadable {
                self.appState[\.conversationData.conversations] = $0
            }
            .store(in: cancelBag)
    }
    
    func deleteConversation(conversationID: Int){
        let cancelBag = CancelBag()
        let conversations = self.appState[\.conversationData.conversations]
        
        self.appState[\.conversationData.conversations] = .loaded(conversations.value?.filter({ $0.id != conversationID
        }) .lazyList ?? [].lazyList)
        
        return Just<Void>
            .withErrorType(Error.self)
            .flatMap({ [conversationRepository] in
                conversationRepository.deleteConversation(conversationID: conversationID).mapError{$0}
            })
            .flatMap({ [conversationDBRepository] in                
                conversationDBRepository.deleteConversation(conversationID: conversationID)
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.appState[\.conversationData.conversations] = conversations
                    break
                }
            }, receiveValue: {
                
            })
            .store(in: cancelBag)
    }
    
    func addConversationToDB(conversation: Conversation){
        _ = conversationDBRepository.store(conversation: conversation)
    }
    
    func deleteConversationAndUpdate(conversationID: Int) {
        let cancelBag = CancelBag()
        if let conversations = appState[\.conversationData.conversations].value {
            appState[\.conversationData.conversations] = .loaded(conversations.filter { $0.id != conversationID }.lazyList)
        }
    
        Just<Void>
            .withErrorType(Error.self)
            .map({ [conversationRepository] in
                _ = conversationRepository.deleteConversation(conversationID: conversationID)
            })
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    break
                case .finished:

                    break
                }
            } receiveValue: { _ in
                
            }
            .store(in: cancelBag)
    }
    
    func loadConversationChat(conversation: LoadableSubject<Conversation>, conversationID: Int){
        let cancelBag = CancelBag()
        conversation.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                self.loadConversationChatFromWeb(conversationID: conversationID)
            }
            .map { [chatService] in
                chatService.loadChatFromDBBy(conversationID: conversationID)
            }
            .flatMap{ publisher in
                convertLazyListChatToConversation(publisher: publisher, conversation: conversation)
            }
            .sinkToLoadable { conversation.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func loadConversationChat(conversation: LoadableSubject<LazyList<Chat>>, conversationID: Int){
        let cancelBag = CancelBag()
        conversation.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                self.loadConversationChatFromWeb(conversationID: conversationID)
            }
            .flatMap { [chatService] in
                chatService.loadChatFromDBBy(conversationID: conversationID)
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
            .mapError({ $0 })
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
                    break
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
        conversationRepository
            .loadConversationList()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [conversationDBRepository] in
                _ = conversationDBRepository.deleteAllConversation()
                
                for conversation in $0 {
                    _ = conversationDBRepository.store(conversation: conversation)
                }
            }
            .mapError{ $0 }
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

extension MainConversationService {
    enum ConversationError: Error {
        case invalidID
    }
}

struct StubConversationService: ConversationService {
    func createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String) {
        
    }
    
    func loadConversationChat(conversation: LoadableSubject<LazyList<Chat>>, conversationID: Int){
    }
    
    func deleteConversation(conversationID: Int){
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
    
    func loadConversationChat(conversation: LoadableSubject<Conversation>, conversationID: Int) {
    }
    
    func deleteConversationAndUpdate(conversationID: Int){
        
    }
    
    func addConversationToDB(conversation: Conversation) {
        
    }
    
    func loadConversationList(){
        
    }
}
