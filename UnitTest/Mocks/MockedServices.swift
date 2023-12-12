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
        permissionsService: [MockedUserPermissionsService.Action] = [],
        journalService: [MockedJournalService.Action] = [],
        chatService: [MockChatService.Action] = [],
        conversationService: [MockConversationService.Action] = [],
        insightService: [MockedInsightsService.Action] = [],
        authenticationService: [MockedAuthenticationService.Action] = [],
        profileService: [MockedProfileService.Action] = []
        
    ) -> DIContainer.Services {
        .init(conversationService: MockConversationService(expected: conversationService), userPermissionsService: MockedUserPermissionsService(expected: permissionsService), authenticationService: MockedAuthenticationService(expected: authenticationService), insightService: MockedInsightsService(expected: insightService), chatService: MockChatService(expected: chatService), journalService: MockedJournalService(expected: journalService), profileService: MockedProfileService(expected: profileService))
    }
    
    func verify(file: StaticString = #file, line: UInt = #line) {
        (journalService as? MockedJournalService)?
            .verify(file: file, line: line)
        (chatService as? MockChatService)?
            .verify(file: file, line: line)
        (conversationService as? MockConversationService)?
            .verify(file: file, line: line)
        (insightService as? MockedInsightsService)?
            .verify(file: file, line: line)
        (authenticationService as? MockedAuthenticationService)?
            .verify(file: file, line: line)
    }
}

// MARK: - JournalServices

struct MockedJournalService: Mock, JournalService {
    enum Action: Equatable {
        static func == (lhs: MockedJournalService.Action, rhs: MockedJournalService.Action) -> Bool {
            switch (lhs, rhs) {
            case (.loadJournalList(let lhsJournals), .loadJournalList(let rhsJournals)):
                return lhsJournals.wrappedValue.value == rhsJournals.wrappedValue.value
            case (.deleteJournal(let lhsJournalID, let lhsJournals), .deleteJournal(let rhsJournalID, let rhsJournals)):
                return lhsJournalID == rhsJournalID && lhsJournals.wrappedValue.value == rhsJournals.wrappedValue.value
            case (.getJournal(let lhsDate, let lhsJournal), .getJournal(let rhsDate, let rhsJournal)):
                return lhsDate == rhsDate && lhsJournal.wrappedValue == rhsJournal.wrappedValue
            case (.saveJournal(let lhsJournal), .saveJournal(let rhsJournal)):
                return lhsJournal.wrappedValue == rhsJournal.wrappedValue
            default:
                return true
            }
        }
        
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
        static func == (lhs: MockChatService.Action, rhs: MockChatService.Action) -> Bool {
            switch (lhs, rhs) {
            case (.loadConversationChat(let lhsChats, let lhsConversationID), .loadConversationChat(let rhsChats, let rhsConversationID)):
                return lhsChats.wrappedValue.value == rhsChats.wrappedValue.value && lhsConversationID == rhsConversationID
            case (.loadChatFromDBBy(let lhsConversationID), .loadChatFromDBBy(let rhsConversationID)):
                return lhsConversationID == rhsConversationID
            case (.getChatsForConversationFromServer(let lhsConversationID), .getChatsForConversationFromServer(let rhsConversationID)):
                return lhsConversationID == rhsConversationID
            case (.saveChatInDB(let lhsChat), .saveChatInDB(let rhsChat)):
                return lhsChat == rhsChat
            case (.sendChatToServer(let lhsMessage, let lhsConversation), .sendChatToServer(let rhsMessage, let rhsConversation)):
                return lhsMessage == rhsMessage && lhsConversation == rhsConversation
            case (.deletePreviousUserMessage, .deletePreviousUserMessage):
                return true
            default:
                return false
            }
        }
        
        case loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int)
        case loadChatFromDBBy(conversationID: Int)
        case getChatsForConversationFromServer(conversationID: Int)
        
        case saveChatInDB(chat: Chat)
        case sendChatToServer(message: String, conversation: Conversation)
        case deletePreviousUserMessage
    }

    let loadChatFromDBByResult: Result<LazyList<Chat>, Error> = .failure(MockError.valueNotSet)
    let getChatsForConversationFromServerResult: Result<LazyList<Chat>, Error> = .failure(MockError.valueNotSet)
    let sendChatToServerResult: Result<Chat, Error> = .failure(MockError.valueNotSet)
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func loadConversationChat(chats: LoadableSubject<LazyList<Chat>>, conversationID: Int){
        register(.loadConversationChat(chats: chats, conversationID: conversationID))
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>{
        register(.loadChatFromDBBy(conversationID: conversationID))
        return loadChatFromDBByResult.publish()
    }
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>{
        register(.getChatsForConversationFromServer(conversationID: conversationID))
        return getChatsForConversationFromServerResult.publish()
    }
    
    func saveChatInDB(chat: Chat){
        register(.saveChatInDB(chat: chat))
    }
    
    func sendChatToServer(message: String, conversation: Conversation) -> AnyPublisher<Chat, Error>{
        register(.sendChatToServer(message: message, conversation: conversation))
        return sendChatToServerResult.publish()
    }
    
    func deletePreviousUserMessage(){
        register(.deletePreviousUserMessage)
    }
}

// MARK: - ConversationService
struct MockConversationService: Mock, ConversationService {
    enum Action: Equatable {
        static func == (lhs: MockConversationService.Action, rhs: MockConversationService.Action) -> Bool {
            switch (lhs, rhs) {
            case (.loadConversationList(let lhsConversations), .loadConversationList(let rhsConversations)):
                return lhsConversations.wrappedValue.value == rhsConversations.wrappedValue.value
            case (.loadConversationChat(let lhsConversation), .loadConversationChat(let rhsConversation)):
                return lhsConversation.wrappedValue == rhsConversation.wrappedValue
            case (.createNewConversation(let lhsConversation, let lhsConversationName), .createNewConversation(let rhsConversation, let rhsConversationName)):
                return lhsConversation.wrappedValue == rhsConversation.wrappedValue && lhsConversationName == rhsConversationName
            case (.deleteConversation(let lhsConversationID), .deleteConversation(let rhsConversationID)):
                return lhsConversationID == rhsConversationID
            default:
                return false
            }
        }
        
        case loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>)
        case loadConversationChat(conversation: LoadableSubject<Conversation>)
        case createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String)
        case deleteConversation(conversationID: Int)
    }
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    let actions: MockActions<Action>
    
    var deleteConversationResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>){
        register(.loadConversationList(conversations: conversations))
    }
    
    func loadConversationChat(conversation: LoadableSubject<Conversation>){
        register(.loadConversationChat(conversation: conversation))
    }
    
    func createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String){
        register(.createNewConversation(conversation: conversation, conversationName: conversationName))
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error> {
        register(.deleteConversation(conversationID: conversationID))
        return deleteConversationResult.publish()
    }
}

// MARK: - UserPermissionsService

class MockedUserPermissionsService: Mock, UserPermissionsService {
    
    enum Action: Equatable {
        case resolveStatus(Permission)
        case request(Permission)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func resolveStatus(for permission: Permission) {
        register(.resolveStatus(permission))
    }
    
    func request(permission: Permission) {
        register(.request(permission))
    }
}

// MARK: - InsightService

struct MockedInsightsService: Mock, InsightService {
    enum Action: Equatable {
        case loadInsight
        case checkInsight
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func loadInsight() {
        register(.loadInsight)
    }
    
    func checkInsight() {
        register(.checkInsight)
    }
}

// MARK: - AuthenticationService

struct MockedAuthenticationService: Mock, AuthenticationService {
    enum Action: Equatable {
        static func == (lhs: MockedAuthenticationService.Action, rhs: MockedAuthenticationService.Action) -> Bool {
            switch (lhs, rhs) {
            case (.loginUser(let lhsEmail, let lhsPassword), .loginUser(let rhsEmail, let rhsPassword)):
                return lhsEmail == rhsEmail && lhsPassword == rhsPassword
            case (.registerUser(let lhsAuth, let lhsEmail, let lhsPassword), .registerUser(let rhsAuth, let rhsEmail, let rhsPassword)):
                return lhsAuth.wrappedValue.value == rhsAuth.wrappedValue.value && lhsEmail == rhsEmail && lhsPassword == rhsPassword
            case (.checkUserLoggedStatus, .checkUserLoggedStatus):
                return true
            default:
                return false
            }
        }
        
        case loginUser(email: String, password: String)
        case registerUser(auth: LoadableSubject<User>, email: String, password: String)
        case checkUserLoggedStatus
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func loginUser(email: String, password: String) {
        register(.loginUser(email: email, password: password))
    }
    
    func registerUser(auth: LoadableSubject<User>, email: String, password: String) {
        register(.registerUser(auth: auth, email: email, password: password))
    }
    
    func checkUserLoggedStatus() {
        register(.checkUserLoggedStatus)
    }
}   

// MARK: - ProfileService

struct MockedProfileService: Mock, ProfileService{
    enum Action: Equatable {
        static func == (lhs: MockedProfileService.Action, rhs: MockedProfileService.Action) -> Bool {
            switch (lhs, rhs) {
            case (.saveProfileImage(let lhsImage), .saveProfileImage(let rhsImage)):
                return lhsImage.id == rhsImage.id
            case (.loadProfileImage, .loadProfileImage):
                return true
            default:
                return false
            }
        }
        
        case saveProfileImage(image: PersistentImageModel)
        case loadProfileImage
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func saveProfileImage(image: PersistentImageModel) {
        register(.saveProfileImage(image: image))
    }
    
    func loadProfileImage() -> AnyPublisher<Image?, Error> {
        register(.loadProfileImage)
        return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
