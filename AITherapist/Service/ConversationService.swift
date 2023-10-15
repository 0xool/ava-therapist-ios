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
    //    func loadConversationChat(message: LoadableSubject<LazyList<Message>>)
}

struct MainConversationService: ConversationService {
    
    let conversationRepository: ConversationRepository
    let conversationDBRepository: ConversationDBRepository
    let chatDBRepository: ChatDBRepository
    let chatWebRepository: ChatRepository
    
    let appState: Store<AppState>
    
    init(conversationRepository: ConversationRepository, appState: Store<AppState>, conversationDBRepository: ConversationDBRepository, chatDBRepository: ChatDBRepository, chatWebRepository: ChatRepository) {
        self.conversationRepository = conversationRepository
        self.conversationDBRepository = conversationDBRepository
        self.chatDBRepository = chatDBRepository
        self.chatWebRepository = chatWebRepository
        self.appState = appState
    }
    
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>) {
        
        let cancelBag = CancelBag()
        conversations.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [conversationDBRepository] _ -> AnyPublisher<Bool, Error> in
                conversationDBRepository.hasLoadedConversation()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.refreshConversationList()
                }
            }
            .flatMap({ [conversationDBRepository] in
                conversationDBRepository.loadConversations()
            })
            .sinkToLoadable { conversations.wrappedValue = $0 }
            .store(in: cancelBag)
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
                return self.loadConversationChatFromWeb(conversationID: id)
            }
            .map { [chatDBRepository] in
                 chatDBRepository.loadChatsBy(conversationID: conversation.wrappedValue.value!.id)
            }
            .flatMap{ publisher in
                convertLazyListChatToConversation(publisher: publisher, conversation: conversation)
            }
            .sinkToLoadable { conversation.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func loadConversationChatFromWeb(conversationID: Int) -> AnyPublisher<Void, Error> {
        return chatWebRepository
            .loadChatsForConversation(conversationID: conversationID)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map{ [chatDBRepository] in
                for chat in $0 {
                    _ = chatDBRepository.store(chat: chat)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func convertLazyListChatToConversation(publisher: AnyPublisher<LazyList<Chat>, Error>,  conversation: LoadableSubject<Conversation>) -> AnyPublisher<Conversation, Error> {
        // add chats to conversation then return AnyPublisher<Conversation, Error>
        return publisher
            .map{
                convertLazyListChatToList(chats: $0)
            }
            .map{
                let conversation = Conversation(id: conversation.wrappedValue.value!.id, conversationName: conversation.wrappedValue.value!.conversationName, date: conversation.wrappedValue.value!.dateCreated)
                for chat in $0.lazyList {
                    conversation.chats.append(chat)
                }
                
//                conversation.wrappedValue = .loaded(convo)
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
                for conversation in $0 {
                    _ = conversationDBRepository.store(conversation: conversation)
                }
            }
            .eraseToAnyPublisher()
    }

    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
    
}

struct StubCountriesService: ConversationService {
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>) {
    }
    
    func loadConversationChat(conversation: LoadableSubject<Conversation>) {
    }
}

// protocol CountriesService {
//     func refreshCountriesList() -> AnyPublisher<Void, Error>
//     func load(countries: LoadableSubject<LazyList<Country>>, search: String, locale: Locale)
//     func load(countryDetails: LoadableSubject<Country.Details>, country: Country)
// }

// struct RealCountriesService: CountriesService {

//     let webRepository: CountriesWebRepository
//     let dbRepository: CountriesDBRepository
//     let appState: Store<AppState>

//     init(webRepository: CountriesWebRepository, dbRepository: CountriesDBRepository, appState: Store<AppState>) {
//         self.webRepository = webRepository
//         self.dbRepository = dbRepository
//         self.appState = appState
//     }

//     func load(countries: LoadableSubject<LazyList<Country>>, search: String, locale: Locale) {

//         let cancelBag = CancelBag()
//         countries.wrappedValue.setIsLoading(cancelBag: cancelBag)

//         Just<Void>
//             .withErrorType(Error.self)
//             .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
//                 dbRepository.hasLoadedCountries()
//             }
//             .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
//                 if hasLoaded {
//                     return Just<Void>.withErrorType(Error.self)
//                 } else {
//                     return self.refreshCountriesList()
//                 }
//             }
//             .flatMap { [dbRepository] in
//                 dbRepository.countries(search: search, locale: locale)
//             }
//             .sinkToLoadable { countries.wrappedValue = $0 }
//             .store(in: cancelBag)
//     }

//     func refreshCountriesList() -> AnyPublisher<Void, Error> {
//         return webRepository
//             .loadCountries()
//             .ensureTimeSpan(requestHoldBackTimeInterval)
//             .flatMap { [dbRepository] in
//                 dbRepository.store(countries: $0)
//             }
//             .eraseToAnyPublisher()
//     }

//     func load(countryDetails: LoadableSubject<Country.Details>, country: Country) {

//         let cancelBag = CancelBag()
//         countryDetails.wrappedValue.setIsLoading(cancelBag: cancelBag)

//         dbRepository
//             .countryDetails(country: country)
//             .flatMap { details -> AnyPublisher<Country.Details?, Error> in
//                 if details != nil {
//                     return Just<Country.Details?>.withErrorType(details, Error.self)
//                 } else {
//                     return self.loadAndStoreCountryDetailsFromWeb(country: country)
//                 }
//             }
//             .sinkToLoadable { countryDetails.wrappedValue = $0.unwrap() }
//             .store(in: cancelBag)
//     }

//     private func loadAndStoreCountryDetailsFromWeb(country: Country) -> AnyPublisher<Country.Details?, Error> {
//         return webRepository
//             .loadCountryDetails(country: country)
//             .ensureTimeSpan(requestHoldBackTimeInterval)
//             .flatMap { [dbRepository] in
//                 dbRepository.store(countryDetails: $0, for: country)
//             }
//             .eraseToAnyPublisher()
//     }

//     private var requestHoldBackTimeInterval: TimeInterval {
//         return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
//     }
// }

// struct StubCountriesService: CountriesService {

//     func refreshCountriesList() -> AnyPublisher<Void, Error> {
//         return Just<Void>.withErrorType(Error.self)
//     }

//     func load(countries: LoadableSubject<LazyList<Country>>, search: String, locale: Locale) {
//     }

//     func load(countryDetails: LoadableSubject<Country.Details>, country: Country) {
//     }
// }




