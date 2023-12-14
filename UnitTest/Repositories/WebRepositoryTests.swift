//
//  WebRepositoryTests.swift
//  UnitTests
//
//  Created by Cyrus Refahi on 10/6/23.
//  Copyright © 2023 Cyrus Refahi. All rights reserved.
//

import XCTest
import Combine
import Alamofire
@testable import AITherapist

final class WebRepositoryTests: XCTestCase {
    
    private var sut: TestWebRepository!
    private var subscriptions = Set<AnyCancellable>()
    
    private typealias API = TestWebRepository.API
    typealias Mock = RequestMocking.MockedResponse
    
    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = TestWebRepository()        
    }
    
    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    func test_webRepository_success() throws {
        let data = TestWebRepository.TestData()
        try mock(.test, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
    }
    
    //    func test_webRepository_parseError() throws {
    //        let data = Country.mockedData
    //        try mock(.test, result: .success(data))
    //        let exp = XCTestExpectation(description: "Completion")
    //        sut.load(.test).sinkToResult { result in
    //            XCTAssertTrue(Thread.isMainThread)
    //            result.assertFailure("The data couldn’t be read because it isn’t in the correct format.")
    //            exp.fulfill()
    //        }.store(in: &subscriptions)
    //        wait(for: [exp], timeout: 2)
    //    }
    
    func test_webRepository_httpCodeFailure() throws {
        let data = TestWebRepository.TestData()
        try mock(.test, result: .success(data), httpCode: 500)
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure("Response status code was unacceptable: 500.")
            exp.fulfill()
        }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
    }
    
    func test_webRepository_networkingError() throws {
        let error = NSError.test
        try mock(.test, result: Result<TestWebRepository.TestData, Error>.failure(error))
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure(error.localizedDescription)
            exp.fulfill()
        }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
    }
    
//    func test_webRepository_requestURLError() {
//        let exp = XCTestExpectation(description: "Completion")
//        sut.load(.urlError).sinkToResult { result in
//            XCTAssertTrue(Thread.isMainThread)
//            result.assertFailure(APIError.invalidURL.localizedDescription)
//            exp.fulfill()
//        }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
//    }
    
//    func test_webRepository_requestBodyError() {
//        let exp = XCTestExpectation(description: "Completion")
//        sut.load(.bodyError).sinkToResult { result in
//            XCTAssertTrue(Thread.isMainThread)
//            result.assertFailure(TestWebRepository.APIError.fail.localizedDescription)
//            exp.fulfill()
//        }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
//    }
    
//    func test_webRepository_loadableError() {
//        let exp = XCTestExpectation(description: "Completion")
//        let expected = APIError.invalidURL.localizedDescription
//        sut.load(.urlError)
//            .sinkToLoadable { loadable in
//                XCTAssertTrue(Thread.isMainThread)
//                XCTAssertEqual(loadable.error?.localizedDescription, expected)
//                exp.fulfill()
//            }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
//    }
    
//    func test_webRepository_noHttpCodeError() throws {
//        let response = URLResponse(url: URL(fileURLWithPath: ""),
//                                   mimeType: "example", expectedContentLength: 0, textEncodingName: nil)
//        let mock = try Mock(apiCall: API.test, customResponse: response)
//        RequestMocking.add(mock: mock)
//        let exp = XCTestExpectation(description: "Completion")
//        sut.load(.test).sinkToResult { result in
//            XCTAssertTrue(Thread.isMainThread)
//            result.assertFailure(APIError.unexpectedResponse.localizedDescription)
//            exp.fulfill()
//        }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
//    }
    
    // MARK: - Helper
    
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}

private extension TestWebRepository {
    func load(_ api: API) -> AnyPublisher<TestData, Error> {
        self.webRequest(api: api)
    }
}


extension TestWebRepository {
    enum API: APICall {
        case test
        case urlError
        case bodyError
        case noHttpCodeError
        
        var url: String{
            if self == .urlError {
                return "😋😋😋"
            }
            return "https://fake.backend.com"
        }
        
        var method: HTTPMethod {
            .post
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            URLEncoding.default
        }
        
        var parameters: Parameters? {
            nil
        }
    }
}

extension TestWebRepository {
    enum APIError: Swift.Error, LocalizedError {
        case fail
        var errorDescription: String? { "fail" }
    }
}

extension TestWebRepository {
    struct TestData: Codable, Equatable, ServerResponse {
        var data: String
        var message: String?
        var code: Int?
        
        let string: String
        let integer: Int
        
        init() {
            string = "some string"
            integer = 42
            message = "data retreived successfully"
            code = 200
            data = "data"
        }
    }
}
