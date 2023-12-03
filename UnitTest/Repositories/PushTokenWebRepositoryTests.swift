//
//  PushTokenWebRepositoryTests.swift
//  UnitTests
//
//  Created by Cyrus Refahi on 10/6/23.
//  Copyright © 2020 Cyrus Refahi. All rights reserved.
//

import XCTest
import Combine
@testable import AITherapist

class PushTokenWebRepositoryTests: XCTestCase {

    private var sut: RealPushTokenWebRepository!
    private var cancelBag = CancelBag()
    
    override func setUp() {
        sut = RealPushTokenWebRepository(session: .mockedResponsesOnly,
                                         baseURL: "https://test.com")
    }
    
    override func tearDown() {
        cancelBag = CancelBag()
    }
    
    func test_register() {
        let exp = XCTestExpectation(description: #function)
        sut.register(devicePushToken: Data())
            .sinkToResult { result in
                result.assertSuccess()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.1)
    }
}
