//
//  AuthenticateDBRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/18/23.
//

import Foundation
import XCTest
@testable import AITherapist

class UserDBRepositoryTests: XCTestCase {
    var mockedStore: MockedPersistentStore!
    var sut: MainUserDBRepository!
    var cancelBag = CancelBag()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = MainUserDBRepository(persistentStore: mockedStore)
        mockedStore.verify()
    }
    
    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        mockedStore = nil
    }
}

class UserDBRepoTest: UserDBRepositoryTests{
    func test1_storeUser() {
        let user = User.mockedUser
        mockedStore.actions = .init(expected: [
            .deleteLast,
            .write
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.store(user: user)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }

    func test2_hasLoadedUser() {
        
        mockedStore.actions = .init(expected: [
            .getCount
        ])
                
        let exp = XCTestExpectation(description: #function)
        sut.hasLoadedUser()
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

    func test3_loadUser() {
        mockedStore.removeAll()
        let user = User.mockedUser
        mockedStore.actions = .init(expected: [
            .getLast
        ])
        
        mockedStore.preLoadData(data: [user])
        
        let exp = XCTestExpectation(description: #function)
        sut.loadUser()
            .sinkToResult { result in
                switch result {
                case .success(let actualUser):
                    XCTAssertEqual(user.id, actualUser.id)
                case .failure(let error):
                    XCTFail("Expected success, but got \(error) instead")
                }
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
}
