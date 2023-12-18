//
//  MockedDBRepositories.swift
//  UnitTests
//
//  Created by Cyrus Refahi on 10/6/23.
//  Copyright © 2023 Cyrus Refahi. All rights reserved.
//

import XCTest
import Combine
@testable import AITherapist

// MARK: - JournalDBRepository

final class MockedJournalDBRepository: Mock, JournalDBRepository {
    
    enum Action: Equatable {
        case storeJournal(journal: Journal, fromServer: Bool)
        case loadJournals
        case deleteJournal(Int)
        case getJournal(Date)
    }
    var actions = MockActions<Action>(expected: [])
    
    var storeJournalResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    var loadJournalsResult: Result<LazyList<Journal>, Error> = .failure(MockError.valueNotSet)
    var getJournalResult: Result<Journal, Error> = .failure(MockError.valueNotSet)
    var deleteJournalResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    
    // MARK: - API
    
    func store(journal: Journal, fromServer: Bool) -> AnyPublisher<Void, Error>
    {
        register(.storeJournal(journal: journal, fromServer: fromServer))
        return storeJournalResult.publish()
    }
    
    func loadJournals() -> AnyPublisher<LazyList<Journal>, Error>{
        register(.loadJournals)
        return loadJournalsResult.publish()
    }
    
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, Error>{
        register(.deleteJournal(journalID))
        return deleteJournalResult.publish()
    }
    
    func getJournal(byDate: Date) -> AnyPublisher<Journal, Error>{
        register(.getJournal(byDate))
        return getJournalResult.publish()
    }
}

// MARK: - ChatDBRepository

final class MockedChatDBRepository: Mock, ChatDBRepository {
    
    enum Action: Equatable {
        case storeChat(chat: Chat)
        case loadChats
        case loadChatsBy(conversationID: Int)
        case deletePreviousChat
    }
    var actions = MockActions<Action>(expected: [])
    
    var storeChatResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    var loadChatsResult: Result<LazyList<Chat>, Error> = .failure(MockError.valueNotSet)
    var loadChatsByResult: Result<LazyList<Chat>, Error> = .failure(MockError.valueNotSet)
    var deletePreviousChatResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    
    // MARK: - API
    
    func store(chat: Chat) -> AnyPublisher<Void, Error>
    {
        register(.storeChat(chat: chat))
        return storeChatResult.publish()
    }
    
    func loadChats() -> AnyPublisher<LazyList<Chat>, Error>{
        register(.loadChats)
        return loadChatsResult.publish()
    }
    
    func loadChatsBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>{
        register(.loadChatsBy(conversationID: conversationID))
        return loadChatsByResult.publish()
    }
    
    func deletePreviousChat() -> AnyPublisher<Void,  Error>{
        register(.deletePreviousChat)
        return deletePreviousChatResult.publish()
    }
}

// MARK: - ConversationDBRepository

final class MockedConversationDBRepository: Mock, ConversationDBRepository {
        
        enum Action: Equatable {
            case hasLoadedConversation
            case storeConversation(conversation: Conversation)
            case loadConversations
            case addChatToConversation(chats: LazyList<Chat>)
            case deleteConversation(conversationID: Int)
        }
        var actions = MockActions<Action>(expected: [])
        
        var hasLoadedConversationResult: Result<Bool, Error> = .failure(MockError.valueNotSet)
        var storeConversationResult: Result<Void, Error> = .failure(MockError.valueNotSet)
        var loadConversationsResult: Result<LazyList<Conversation>, Error> = .failure(MockError.valueNotSet)
        var addChatToConversationResult: Result<Void, Error> = .failure(MockError.valueNotSet)
        var deleteConversationResult: Result<Void, Error> = .failure(MockError.valueNotSet)
        
        // MARK: - API
        
        func hasLoadedConversation() -> AnyPublisher<Bool, Error>
        {
            register(.hasLoadedConversation)
            return hasLoadedConversationResult.publish()
        }
        
        func store(conversation: Conversation) -> AnyPublisher<Void, Error>{
            register(.storeConversation(conversation: conversation))
            return storeConversationResult.publish()
        }
        
        func loadConversations() -> AnyPublisher<LazyList<Conversation>, Error>{
            register(.loadConversations)
            return loadConversationsResult.publish()
        }
        
        func addChatToConversation(chats: LazyList<Chat>) -> AnyPublisher<Void, Error>{
            register(.addChatToConversation(chats: chats))
            return addChatToConversationResult.publish()
        }
        
        func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>{
            register(.deleteConversation(conversationID: conversationID))
            return deleteConversationResult.publish()
        }
    }

// MARK: - UserDBRepository

final class MockedUserDBRepository: Mock, UserDBRepository {
        
        enum Action: Equatable {
            case hasLoadedUser
            case storeUser(user: User)
            case loadUser
        }
        var actions = MockActions<Action>(expected: [])
        
        var hasLoadedUserResult: Result<Bool, Error> = .failure(MockError.valueNotSet)
        var storeUserResult: Result<Void, Error> = .failure(MockError.valueNotSet)
        var loadUserResult: Result<User, Error> = .failure(MockError.valueNotSet)
        
        // MARK: - API
        
        func hasLoadedUser() -> AnyPublisher<Bool, Error>
        {
            register(.hasLoadedUser)
            return hasLoadedUserResult.publish()
        }
        
        func store(user: User) -> AnyPublisher<Void, Error>{
            register(.storeUser(user: user))
            return storeUserResult.publish()
        }
        
        func loadUser() -> AnyPublisher<User, Error>{
            register(.loadUser)
            return loadUserResult.publish()
        }
    }

// MARK: - InsightsDBRepository

final class MockedInsightsDBRepository: Mock, InsightDBRepository {
        
        enum Action: Equatable {
            case hasLoadedInsight
            case storeInsight(insight: Insight)
            case loadInsight
        }
        var actions = MockActions<Action>(expected: [])
        
        var hasLoadedInsightResult: Result<Bool, Error> = .failure(MockError.valueNotSet)
        var storeInsightResult: Result<Void, Error> = .failure(MockError.valueNotSet)
        var loadInsightResult: Result<Insight, Error> = .failure(MockError.valueNotSet)
        
        // MARK: - API
        
        func hasLoadedInsight() -> AnyPublisher<Bool, Error>
        {
            register(.hasLoadedInsight)
            return hasLoadedInsightResult.publish()
        }
        
        func store(insight: Insight) -> AnyPublisher<Void, Error>{
            register(.storeInsight(insight: insight))
            return storeInsightResult.publish()
        }
        
        func loadInsight() -> AnyPublisher<Insight, Error>{
            register(.loadInsight)
            return loadInsightResult.publish()
        }
    }

    
