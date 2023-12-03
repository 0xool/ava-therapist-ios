//
//  MockedServices.swift
//  UnitTests
//
//  Created by Cyrus Refahi on 10/6/23.
//  Copyright © 2023 Cyrus Refahi. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
import ViewInspector
@testable import AITherapist

extension DIContainer.Services {
    static func mocked(
        countriesService: [MockedCountriesService.Action] = [],
        imagesService: [MockedImagesService.Action] = [],
        permissionsService: [MockedUserPermissionsService.Action] = [],
        journalService: [MockedJournalService.Action] = [],
        chatService: [MockChatService.Action] = [],
        conversationService: [MockConversationService.Action] = [],
        userService: [MockUserService.Action] = [],
        insightsService: [MockedInsightsService.Action] = [],
        authenticationService: [MockedAuthenticationService.Action] = []
    ) -> DIContainer.Services {
        .init(countriesService: MockedCountriesService(expected: countriesService),
              imagesService: MockedImagesService(expected: imagesService),
              userPermissionsService: MockedUserPermissionsService(expected: permissionsService),
              journalService: MockedJournalService(expected: journalService),
              chatService: MockChatService(expected: chatService),
              conversationService: MockConversationService(expected: conversationService),
              userService: MockUserService(expected: userService),
              insightsService: MockedInsightsService(expected: insightsService),
              authenticationService: MockedAuthenticationService(expected: authenticationService))
    }
    
    func verify(file: StaticString = #file, line: UInt = #line) {
        (countriesService as? MockedCountriesService)?
            .verify(file: file, line: line)
        (imagesService as? MockedImagesService)?
            .verify(file: file, line: line)
        (userPermissionsService as? MockedUserPermissionsService)?
            .verify(file: file, line: line)
        (journalService as? MockedJournalService)?
            .verify(file: file, line: line)
        (chatService as? MockChatService)?
            .verify(file: file, line: line)
        (conversationService as? MockConversationService)?
            .verify(file: file, line: line)
        (userService as? MockUserService)?
            .verify(file: file, line: line)
        (insightsService as? MockedInsightsService)?
            .verify(file: file, line: line)
        (authenticationService as? MockedAuthenticationService)?
            .verify(file: file, line: line)
    }
}

// MARK: - JournalServices

struct MockedJournalService: Mock, JournalService {
    enum Action: Equatable {
        case saveJournal(journal: Journal, journals: LoadableSubject<DiaryBook>)
        case loadJournalList(LoadableSubject<DiaryBook>)
        case deleteJournal(journalID: Int, journals: LoadableSubject<DiaryBook>)
        
        case getJournal(byDate: Date, journal: LoadableSubject<Journal>)
        case saveJournal(LoadableSubject<Journal>)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func loadJournalList(journals: LoadableSubject<DiaryBook>){
        register(.loadJournalList(journals))
    }
    
    func deleteJournal(journalID: Int, journals: LoadableSubject<DiaryBook>){
        register(.deleteJournal(journalID: journalID, journals: journals))
    }
    
    func saveJournal(journal: Journal, journals: LoadableSubject<DiaryBook>){
        register(.saveJournal(journal: journal, journals: journals))
    }
    
    func saveJournal(journal: LoadableSubject<Journal>){
        register(.saveJournal(journal))
    }
    
    func getJournal(byDate: Date, journal: LoadableSubject<Journal>){
        register(.getJournal(byDate: byDate, journal: journal))
    }
    
}

// MARK: ChatService
struct MockChatService: Mock, ChatService {
    enum Action: Equatable {
        case loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int)
        case loadChatFromDBBy(Int)
        case getChatsForConversationFromServer(Int) 
        
        case saveChatInDB(Chat)
        case sendChatToServer(message: String, conversation: Conversation)
        case deletePreviousUserMessage
    }
    
    let actions: MockActions<Action>

    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int){
        register(.loadConversationChat(chats: chats, conversationID: conversationID))
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        register(.loadChatFromDBBy(conversationID))
        return Just<LazyList<Chat>>.withErrorType(Error.self)
    }
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        register(.getChatsForConversationFromServer(conversationID))
        return Just<LazyList<Chat>>.withErrorType(Error.self)
    }
    
    func saveChatInDB(chat: Chat){
        register(.saveChatInDB(chat))
    }

    func sendChatToServer(message: String, conversation: Conversation) -> AnyPublisher<Chat, Error> {
        register(.sendChatToServer(message: message, conversation: conversation))
        return Just<Chat>.withErrorType(Error.self)
    }

    func deletePreviousUserMessage() {
        register(.deletePreviousUserMessage)
    }
}

// MARK: - ConversationService
struct MockConversationService: Mock, ConversationService {
    enum Action: Equatable {
        case loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>)
        case loadConversationListFromDB
        case loadConversationListFromServer
        case saveConversationListToDB(LazyList<Conversation>)
        case saveConversationToDB(Conversation)
        case saveConversationToServer(Conversation)
        case deleteConversationFromDB(Conversation)
        case deleteConversationFromServer(Conversation)
    }
    
    let actions: MockActions<Action>
    
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>){
        register(.loadConversationList(conversations: conversations))
    }
    
    func loadConversationListFromDB() -> AnyPublisher<LazyList<Conversation>, Error> {
        register(.loadConversationListFromDB)
        return Just<LazyList<Conversation>>.withErrorType(Error.self)
    }
    
    func loadConversationListFromServer() -> AnyPublisher<LazyList<Conversation>, Error> {
        register(.loadConversationListFromServer)
        return Just<LazyList<Conversation>>.withErrorType(Error.self)
    }
    
    func saveConversationListToDB(conversations: LazyList<Conversation>) {
        register(.saveConversationListToDB(conversations))
    }
    
    func saveConversationToDB(conversation: Conversation) {
        register(.saveConversationToDB(conversation))
    }
    
    func saveConversationToServer(conversation: Conversation) -> AnyPublisher<Conversation, Error> {
        register(.saveConversationToServer(conversation))
        return Just<Conversation>.withErrorType(Error.self)
    }
    
    func deleteConversationFromDB(conversation: Conversation) {
        register(.deleteConversationFromDB(conversation))
    }
    
    func deleteConversationFromServer(conversation: Conversation) -> AnyPublisher<Conversation, Error> {
        register(.deleteConversationFromServer(conversation))
        return Just<Conversation>.withErrorType(Error.self)
    }
}

// MARK: - UserService
struct MockUserService: Mock, UserService {
    enum Action: Equatable {
        case loadUser(user: LoadableSubject<User>)
        case saveUser(user: LoadableSubject<User>)
        case saveUserToDB(user: User)
        case saveUserToServer(user: User)
        case loadUserFromDB
        case loadUserFromServer
        case deleteUserFromDB
        case deleteUserFromServer
    }
    
    let actions: MockActions<Action>
    
    func loadUser(user: LoadableSubject<User>){
        register(.loadUser(user: user))
    }
    
    func saveUser(user: LoadableSubject<User>){
        register(.saveUser(user: user))
    }
    
    func saveUserToDB(user: User) {
        register(.saveUserToDB(user: user))
    }
    
    func saveUserToServer(user: User) -> AnyPublisher<User, Error> {
        register(.saveUserToServer(user: user))
        return Just<User>.withErrorType(Error.self)
    }
    
    func loadUserFromDB() -> AnyPublisher<User, Error> {
        register(.loadUserFromDB)
        return Just<User>.withErrorType(Error.self)
    }
    
    func loadUserFromServer() -> AnyPublisher<User, Error> {
        register(.loadUserFromServer)
        return Just<User>.withErrorType(Error.self)
    }
    
    func deleteUserFromDB() {
        register(.deleteUserFromDB)
    }
    
    func deleteUserFromServer() -> AnyPublisher<User, Error> {
        register(.deleteUserFromServer)
        return Just<User>.withErrorType(Error.self)
    }
}

// MARK: - UserPermissionsService
struct MockUserPermissionsService: Mock, UserPermissionsService {
    enum Action: Equatable {
        case resolveStatus(Permission)
        case request(Permission)
    }
    
    let actions: MockActions<Action>
    
    func resolveStatus(for permission: Permission) {
        register(.resolveStatus(for: permission))
    }
    
    func request(permission: Permission) {
        register(.request(permission: permission))
    }
}

// MARK: - InsightsService

struct MockedInsightsService: Mock, InsightsService {
    enum Action: Equatable {
        case loadInsights(insights: LoadableSubject<LazyList<Insight>>)
        case loadInsightsFromDB
        case loadInsightsFromServer
        case saveInsightsToDB(LazyList<Insight>)
        case saveInsightToDB(Insight)
        case saveInsightToServer(Insight)
        case deleteInsightFromDB(Insight)
        case deleteInsightFromServer(Insight)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func loadInsights(insights: LoadableSubject<LazyList<Insight>>){
        register(.loadInsights(insights: insights))
    }
    
    func loadInsightsFromDB() -> AnyPublisher<LazyList<Insight>, Error> {
        register(.loadInsightsFromDB)
        return Just<LazyList<Insight>>.withErrorType(Error.self)
    }
    
    func loadInsightsFromServer() -> AnyPublisher<LazyList<Insight>, Error> {
        register(.loadInsightsFromServer)
        return Just<LazyList<Insight>>.withErrorType(Error.self)
    }
    
    func saveInsightsToDB(insights: LazyList<Insight>) {
        register(.saveInsightsToDB(insights))
    }
    
    func saveInsightToDB(insight: Insight) {
        register(.saveInsightToDB(insight))
    }
    
    func saveInsightToServer(insight: Insight) -> AnyPublisher<Insight, Error> {
        register(.saveInsightToServer(insight))
        return Just<Insight>.withErrorType(Error.self)
    }
    
    func deleteInsightFromDB(insight: Insight) {
        register(.deleteInsightFromDB(insight))
    }
    
    func deleteInsightFromServer(insight: Insight) -> AnyPublisher<Insight, Error> {
        register(.deleteInsightFromServer(insight))
        return Just<Insight>.withErrorType(Error.self)
    }
}

// MARK: - AuthenticationService
struct MockedAuthenticationService: Mock, AuthenticationService {
    enum Action: Equatable {
        case login(email: String, password: String)
        case signup(email: String, password: String)
        case logout
        case resetPassword(email: String)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        register(.login(email: email, password: password))
        return Just<User>.withErrorType(Error.self)
    }
    
    func signup(email: String, password: String) -> AnyPublisher<User, Error> {
        register(.signup(email: email, password: password))
        return Just<User>.withErrorType(Error.self)
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        register(.logout)
        return Just<Void>.withErrorType(Error.self)
    }
    
    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        register(.resetPassword(email: email))
        return Just<Void>.withErrorType(Error.self)
    }
}
