//
//  JournalWebRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/12/23.
//

import XCTest
import Combine
import Alamofire
@testable import AITherapist

final class InsightWebRepositoryTests: XCTestCase {
    private var sut: MainInsightWebRepository!
    private var subscriptions = Set<AnyCancellable>()

    typealias API = MainInsightWebRepository.API
    typealias Mock = RequestMocking.MockedResponse
    typealias MockInterceptor = RequestMocking.MockInterceptor

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        let session = Session(interceptor: MockInterceptor())

        sut = MainInsightWebRepository(session: .mockedResponsesOnly, baseURL: "https://test.com")
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

    func test_loadInsight() throws {
        let data = Insight.mockedInsight
        try mock(.getInsight, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadInsight().sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        // wait(for: [exp], timeout: 2)
    }
}
