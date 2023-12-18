//
//  ConversationDBRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/17/23.
//

import Foundation
import XCTest
@testable import AITherapist

class ConversationDBRepositoryTests: XCTestCase {
    var mockedStore: MockedPersistentStore!
    var sut: MainConversationDBRepository!
    var cancelBag = CancelBag()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = MainConversationDBRepository(persistentStore: mockedStore)
        mockedStore.verify()
    }
    
    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        mockedStore = nil
    }
}

final class ConversationDBRepoTest: ConversationDBRepositoryTests {
    func test2_hasLoadedConversation() {
        
        let conversations = Conversation.mockedConversations
        mockedStore.actions = .init(expected: [
            .getCount
        ])
                
        let exp = XCTestExpectation(description: #function)
        sut.hasLoadedConversation()
            .sinkToResult { result in
                switch result {
                case .success(let hasLoaded):
                    XCTAssertTrue(hasLoaded)
                case .failure(let error):
                    XCTFail("Expected success, but got \(error) instead")
                }
                
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }

    func test1_storeConversation() {
        let conversation = Conversation.mockedConversation
        mockedStore.actions = .init(expected: [
            .write
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.store(conversation: conversation)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }

    func test_loadConversation() {
        mockedStore.removeAll()
        let conversations = Conversation.mockedConversations
        mockedStore.actions = .init(expected: [
            .getAll
        ])
        
        mockedStore.preLoadData(data: conversations)
        
        let exp = XCTestExpectation(description: #function)
        sut.loadConversations()
            .sinkToResult { result in
                switch result {
                case .success(let actualConversations):
                    for (expectedConversation, actualConversation) in zip(conversations, actualConversations) {
                        XCTAssertEqual(expectedConversation.id, actualConversation.id)
                    }
                case .failure(let error):
                    XCTFail("Expected success, but got \(error) instead")
                }
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }

    func test3_addChatToConversation() {
        let chats = Chat.mockedChatList
        mockedStore.actions = .init(expected: [
            .getByID(chats[0].conversationID),
            .update
        ])
        
        mockedStore.preLoadData(data: chats)

        let exp = XCTestExpectation(description: #function)
        sut.addChatToConversation(chats: chats.lazyList)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }

    func test4_deleteConversation() {
        let conversation = Conversation.mockedConversation
        mockedStore.actions = .init(expected: [
            .deleteByID(conversation.id)
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.deleteConversation(conversationID: conversation.id)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
}

