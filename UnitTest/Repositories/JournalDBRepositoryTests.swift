//
//  JournalDBRepositoryTests.swift
//  AITherapistTests
//
//  Created by Cyrus Refahi on 12/11/23.
//

import Foundation
import XCTest
@testable import AITherapist

class JournalDBRepositoryTests: XCTestCase {
    var mockedStore: MockedPersistentStore!
    var sut: MainJournalDBRepository!
    var cancelBag = CancelBag()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = MainJournalDBRepository(persistentStore: mockedStore)
        mockedStore.verify()
    }
    
    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        mockedStore = nil
    }
}

final class JournalDBRepoTest: JournalDBRepositoryTests {
  
    func test1_sotreJournalFromServer() {
        let data = Journal.mockedJournal
        mockedStore.actions = .init(expected: [
            .getByQuery,
            .deleteByID(1),
            .write

        ])
        let exp = XCTestExpectation(description: #function)
        sut.store(journal: data, fromServer: false)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test1_sotreJournalFromLocal() {
        let data = Journal.mockedJournal
        mockedStore.actions = .init(expected: [
            .getByQuery,
            .deleteByID(1),
            .write
        ])
        let exp = XCTestExpectation(description: #function)
        sut.store(journal: data, fromServer: true)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test2_getJournalByDate() {
        let journal = Journal.mockedJournal
        mockedStore.actions = .init(expected: [
            .getByQuery
        ])

        let exp = XCTestExpectation(description: #function)
        sut.getJournal(byDate: journal.dateCreated)
            .sinkToResult { result in
                result.assertSuccess(value: journal)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test2_loadJournals() {
        let journals = [Journal.mockedJournals[0]]
        mockedStore.actions = .init(expected: [
            .getAll
        ])
        
        let exp = XCTestExpectation(description: #function)
        sut.loadJournals()
            .sinkToResult { result in
                switch result {
                        case .success(let actualJournals):
                            XCTAssertEqual(journals.count, actualJournals.count)
                            for (expectedJournal, actualJournal) in zip(journals, actualJournals) {
                                XCTAssertEqual(expectedJournal.id, actualJournal.id)
                            }
                        case .failure(let error):
                            XCTFail("Expected success, but got \(error) instead")
                        }
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
    func test3_deleteJournal() {
        let journal = Journal.mockedJournal
        mockedStore.actions = .init(expected: [
            .deleteByID(journal.id)
        ])

        let exp = XCTestExpectation(description: #function)
        sut.deleteJournal(journalID: journal.id)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
    }
    
}


