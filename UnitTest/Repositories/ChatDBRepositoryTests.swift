//
//  ChatDBRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/17/23.
//

import Foundation
import XCTest
@testable import AITherapist

class ChatDBRepositoryTests: XCTestCase {
    var mockedStore: MockedPersistentStore!
    var sut: MainChatDBRepository!
    var cancelBag = CancelBag()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = MainChatDBRepository(persistentStore: mockedStore)
        mockedStore.verify()
    }
    
    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        mockedStore = nil
    }
}

final class ChatDBRepoTest: ChatDBRepositoryTests {

    func test_storeChat() {
        let chat = Chat.mockedChat
        mockedStore.actions = .init(expected: [
            .write
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.store(chat: chat)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test2_loadChats() {
        mockedStore.removeAll()
        let chats = Chat.mockedChatList
        mockedStore.actions = .init(expected: [
            .getAll
        ])
        
        mockedStore.preLoadData(data: chats)
        
        let exp = XCTestExpectation(description: #function)
        sut.loadChats()
            .sinkToResult { result in
                switch result {
                case .success(let actualChats):
                    for (expectedChat, actualChat) in zip(chats, actualChats) {
                        XCTAssertEqual(expectedChat.id, actualChat.id)
                    }
                case .failure(let error):
                    XCTFail("Expected success, but got \(error) instead")
                }
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test3_loadChatsByConversationID() {
        let chats = Chat.mockedChatList
        mockedStore.actions = .init(expected: [
            .getByTypeID(chats[0].conversationID)
        ])
        
        mockedStore.preLoadData(data: chats)

        let exp = XCTestExpectation(description: #function)
        sut.loadChatsBy(conversationID: chats[0].conversationID)
            .sinkToResult { result in
                switch result {
                case .success(let actualChats):
                    for (expectedChat, actualChat) in zip(chats, actualChats) {
                        XCTAssertEqual(expectedChat.id, actualChat.id)
                    }
                case .failure(let error):
                    XCTFail("Expected success, but got \(error) instead")
                }
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test4_deletePreviousChat() {
        let chat = Chat.mockedChat
        mockedStore.actions = .init(expected: [
            .deleteLast
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.deletePreviousChat()
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
}

