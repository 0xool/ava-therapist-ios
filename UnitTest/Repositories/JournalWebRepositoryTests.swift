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

final class JournalWebRepositoryTests: XCTestCase {
    private var sut: MainJournalWebRepository!
    private var subscriptions = Set<AnyCancellable>()
    
    typealias API = MainJournalWebRepository.API
    typealias Mock = RequestMocking.MockedResponse
    typealias MockInterceptor = RequestMocking.MockInterceptor
    
    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        let session = Session(interceptor: MockInterceptor())
        
        sut = MainJournalWebRepository(baseURL: "https://test.com", session: .mockedResponsesOnly)
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
    
    func test_loadJournalList() throws {
        let data = Journal.mockedJournals
        let diaryBook = DiaryBook(journals: data)
        try mock(.allJournals, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadJournalList().sinkToResult { result in
            result.assertSuccess(value: diaryBook)
            exp.fulfill()
        }.store(in: &subscriptions)
//        wait(for: [exp], timeout: 2)
    }
    
    func test_addJournal() throws {
        let exp = XCTestExpectation(description: "Completion")
        sut.addJournal(journal: Journal()).sinkToResult { result in
            result.assertSuccess()
            exp.fulfill()
        }.store(in: &subscriptions)
//    wait(for: [exp], timeout: 2)
    }
    
    func test_deleteJournal() throws {
        let exp = XCTestExpectation(description: "Completion")
        sut.deleteJournal(journalID: 1).sinkToResult { result in
            result.assertSuccess()
            exp.fulfill()
        }.store(in: &subscriptions)
//    wait(for: [exp], timeout: 2)

    }

    func test_getJournalByDate() throws {
        let data = Journal.mockedJournal
        try mock(.getDiaryByDate(date: Date.now.description), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.getJournalByDate(date: Date()).sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
//    wait(for: [exp], timeout: 2)
    }
    
}

