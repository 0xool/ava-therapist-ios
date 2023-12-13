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
        case loadJournalList
        case deleteJournal(Int)
        
        case getJournal(Date)
        case saveJournal
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func loadJournalList(journals: LoadableSubject<DiaryBook>){
        register(.loadJournalList)
    }
    
    func deleteJournal(journalID: Int, journals: LoadableSubject<DiaryBook>){
        register(.deleteJournal(journalID))
    }
    
    func saveJournal(journal: Journal, journals: LoadableSubject<DiaryBook>){
//        register(.saveJournal(journal: journal, journals: journals))
    }
    
    func saveJournal(journal: LoadableSubject<Journal>){
        register(.saveJournal)
    }
    
    func getJournal(byDate: Date, journal: LoadableSubject<Journal>){
        register(.getJournal(byDate))
    }
}

// MARK: ChatService

struct MockChatService: Mock, ChatService {

    enum Action: Equatable {        
        case loadConversationChat(Int)
        case loadChatFromDBBy(Int)
        case getChatsForConversationFromServer(Int)
        
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
        register(.loadConversationChat(conversationID))
    }
    
    func loadChatFromDBBy(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>{
        register(.loadChatFromDBBy(conversationID))
        return loadChatFromDBByResult.publish()
    }
    
    func getChatsForConversationFromServer(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>{
        register(.getChatsForConversationFromServer(conversationID))
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
        case loadConversationList
        case loadConversationChat
        case createNewConversation(String)
        case deleteConversation(Int)
    }
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    let actions: MockActions<Action>
    
    var deleteConversationResult: Result<Void, Error> = .failure(MockError.valueNotSet)
    
    func loadConversationList(conversations: LoadableSubject<LazyList<Conversation>>){
        register(.loadConversationList)
    }
    
    func loadConversationChat(conversation: LoadableSubject<Conversation>){
        register(.loadConversationChat)
    }
    
    func createNewConversation(conversation: LoadableSubject<Conversation>, conversationName: String){
        register(.createNewConversation(conversationName))
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error> {
        register(.deleteConversation(conversationID))
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
        case loginUser(email: String, password: String)
        case registerUser(email: String, password: String)
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
        register(.registerUser(email: email, password: password))
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
