//
//  InsightDBRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/17/23.
//

import Foundation
import XCTest
@testable import AITherapist

class InsightDBRepositoryTests: XCTestCase {
    var mockedStore: MockedPersistentStore!
    var sut: MainInsightDBRepository!
    var cancelBag = CancelBag()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = MainInsightDBRepository(persistentStore: mockedStore)
        mockedStore.verify()
    }
    
    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        mockedStore = nil
    }
}

final class InsightDBRepoTest: InsightDBRepositoryTests {
    
    func test_storeInsight() {
        let insight = Insight.mockedInsight
        mockedStore.actions = .init(expected: [
            .deleteLast,
            .write
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.store(insight: insight)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test2_loadInsight() {
        let insight = Insight.mockedInsight
        mockedStore.actions = .init(expected: [
            .getLast
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.loadInsight()
            .sinkToResult { result in
                switch result {
                case .success(let actualInsight):
                    XCTAssertEqual(insight.id, actualInsight.id)
                case .failure(let error):
                    XCTFail("Expected success, but got \(error) instead")
                }
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test3_hasLoadedInsight() {
        let insight = Insight.mockedInsight
        mockedStore.actions = .init(expected: [
            .getCount
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.hasLoadedInsight()
            .sinkToResult { result in
                result.assertSuccess(value: true)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
}
