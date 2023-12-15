//
//  ConversationWebRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/14/23.
//

import XCTest
import Combine
import Alamofire
@testable import AITherapist

final class ConversationWebRepositoryTests: XCTestCase {
    private var sut: MainConversationWebRepository!
    private var subscriptions = Set<AnyCancellable>()

    typealias API = MainConversationWebRepository.API
    typealias Mock = RequestMocking.MockedResponse
    typealias MockInterceptor = RequestMocking.MockInterceptor

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        let session = Session(interceptor: MockInterceptor())

        sut = MainConversationWebRepository(baseURL: "https://test.com", session: .mockedResponsesOnly)
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

    func test_loadConversationList() throws {
        let data = Conversation.mockedConversations
        try mock(.getConversationList, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadConversationList().sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }

    func test_addConversation() throws {
        let data = Conversation.mockedConversation
        try mock(.addConversation(params: nil), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.addConversation(data: .init(conversation: .init(conversationName: "convo"))).sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }

    func test_deleteConversation() throws {
        let exp = XCTestExpectation(description: "Completion")
        sut.deleteConversation(conversationID: 1).sinkToResult { result in
            result.assertSuccess()
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }
}
