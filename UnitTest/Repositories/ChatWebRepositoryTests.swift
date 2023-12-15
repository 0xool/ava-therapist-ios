//
//  ChatWebRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/14/23.
//

import XCTest
import Combine
import Alamofire
@testable import AITherapist

final class ChatWebRepositoryTests: XCTestCase {
    private var sut: MainChatWebRepository!
    private var subscriptions = Set<AnyCancellable>()

    typealias API = MainChatWebRepository.API
    typealias Mock = RequestMocking.MockedResponse
    typealias MockInterceptor = RequestMocking.MockInterceptor

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        let session = Session(interceptor: MockInterceptor())

        sut = MainChatWebRepository(baseURL: "https://test.com", session: .mockedResponsesOnly)
        sut.AFSession = session
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }

    func test_loadChatsForConversation() throws {
        let data = Chat.mockedChatList
        try mock(.getConversationChats(conversationID: 1), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadChatsForConversation(conversationID: 1).sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }

    func test_sendChatToServer() throws {
        let data = Chat.mockedChat
        try mock(.addChat(params: nil), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.sendChatToServer(data: .init(chat: .init(message: "test", conversationID: 1))).sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }
}
