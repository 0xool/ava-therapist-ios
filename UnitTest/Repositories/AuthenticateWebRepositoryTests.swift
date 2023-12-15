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

final class AuthenticateRepositoryTests: XCTestCase {
    private var sut: MainAuthenticateWebRepository!
    private var subscriptions = Set<AnyCancellable>()

    typealias API = MainAuthenticateWebRepository.API
    typealias Mock = RequestMocking.MockedResponse
    typealias MockInterceptor = RequestMocking.MockInterceptor

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        let session = Session(interceptor: MockInterceptor())

        sut = MainAuthenticateWebRepository(baseURL: "https://test.com", session: .mockedResponsesOnly)
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

    func test_login() throws {
        let data = User.mockedUser
        try mock(.login(params: nil), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.login(email: "test", password: "test").sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }

    func test_register() throws {
        let data = User.mockedUser
        try mock(.register(email: "test", password: "test"), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.register(email: "test", password: "test").sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }
}
