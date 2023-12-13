//
//  MockedWebRepositories.swift
//  UnitTests
//
//  Created by Cyrus Refahi on 10/6/23.
//  Copyright © 2023 Cyrus Refahi. All rights reserved.
//

import XCTest
import Combine
import Alamofire
@testable import AITherapist

class TestWebRepository: WebRepository{
    var AFSession: Session = setAFSession(.mockedResponsesOnly, queue: DispatchQueue(label: "test"))
    let baseURL = "https://test.com"
    let session: URLSession = .mockedResponsesOnly
    let bgQueue = DispatchQueue(label: "test")
}

// MARK: - JournalWebRepository

final class MockedJournalWebRepository: TestWebRepository, Mock, JournalWebRepository {
    
    enum Action: Equatable {
        case loadJournalList
        case addJournal(Journal)
        case deleteJournal(Int)
        case getJournalByDate(Date)
    }
    var actions = MockActions<Action>(expected: [])
    
    var loadJournalListResult: Result<DiaryBook, Error> = .failure(MockError.valueNotSet)
    var addJournalResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    var deleteJournalResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    var getJournalByDateResult: Result<Journal, Error> = .failure(MockError.valueNotSet)
    
    func loadJournalList() -> AnyPublisher<DiaryBook, Error> {
        register(.loadJournalList)
        return loadJournalListResult.publish()
    }
    
    func addJournal(journal: Journal) -> AnyPublisher<Void, Error> {
        register(.addJournal(journal))
        return addJournalResult.publish()
    }
    
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, Error> {
        register(.deleteJournal(journalID))
        return deleteJournalResult.publish()
    }
    
    func getJournalByDate(date: Date) -> AnyPublisher<Journal, Error> {
        register(.getJournalByDate(date))
        return getJournalByDateResult.publish()
    }
}

// MARK: - ConversationWebRepository

final class MockedConversationWebRepository: TestWebRepository, Mock, ConversationWebRepository {
    
    enum Action: Equatable {        
        case loadConversationList
        case addConversation(AddConversationRequest)
        case deleteConversation(Int)
    }
    var actions = MockActions<Action>(expected: [])
    
    var loadConversationListResult: Result<[Conversation], Error> = .failure(MockError.valueNotSet)
    var addConversationResult: Result<Conversation, Error> = .failure(MockError.valueNotSet)
    var deleteConversationResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    
    func loadConversationList() -> AnyPublisher<[Conversation], Error> {
        register(.loadConversationList)
        return loadConversationListResult.publish()
    }
    
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Conversation, Error> {
        register(.addConversation(data))
        return addConversationResult.publish()
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error> {
        register(.deleteConversation(conversationID))
        return deleteConversationResult.publish()
    }
}

// MARK: ChatWebRepository

final class MockedChatWebRepository: TestWebRepository, Mock, ChatWebRepository {
    
    enum Action: Equatable {
        case loadChatsForConversation(Int)
        case sendChatToServer(SaveChatRequset)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var loadChatsForConversationResult: Result<LazyList<Chat>, Error> = .failure(MockError.valueNotSet)
    var sendChatToServerResult: Result<Chat, Error> = .failure(MockError.valueNotSet)
    
    func loadChatsForConversation(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        register(.loadChatsForConversation(conversationID))
        return loadChatsForConversationResult.publish()
    }
    
    func sendChatToServer(data: SaveChatRequset) -> AnyPublisher<Chat, Error> {
        register(.sendChatToServer(data))
        return sendChatToServerResult.publish()
    }
}

// MARK: - AuthenicationWebRepository

final class MockedAuthenticateWebRepository: TestWebRepository, Mock, AuthenticateWebRepository {
    enum Action: Equatable {
        case login(String, String)
        case register(String, String)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var loginResult: Result<User, Error> = .failure(MockError.valueNotSet)
    var registerResult: Result<UserServerResponse, Error> = .failure(MockError.valueNotSet)
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        register(.login(email, password))
        return loginResult.publish()
    }
    
    func register(email: String, password: String) -> AnyPublisher<UserServerResponse, Error> {
        register(.register(email, password))
        return registerResult.publish()
    }
}

// MARK: - InsightWebRepository

final class MockedInsightWebRepository: TestWebRepository, Mock, InsightWebRepository {
    
    enum Action: Equatable {
        case loadInsight
    }
    var actions = MockActions<Action>(expected: [])
    
    var loadInsightResult: Result<Insight, Error> = .failure(MockError.valueNotSet)
    
    func loadInsight() -> AnyPublisher<Insight, Error> {
        register(.loadInsight)
        return loadInsightResult.publish()
    }
}

// MARK: - PushTokenWebRepository

final class MockedPushTokenWebRepository: TestWebRepository, Mock, PushTokenWebRepository {
    enum Action: Equatable {
        case register(Data)
    }
    var actions = MockActions<Action>(expected: [])
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func register(devicePushToken: Data) -> AnyPublisher<Void, Error> {
        register(.register(devicePushToken))
        return Just<Void>.withErrorType(Error.self)
    }
}
