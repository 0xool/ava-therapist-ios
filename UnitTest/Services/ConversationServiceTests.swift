//
//  ConversationService.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/18/23.
//

import XCTest
import SwiftUI
import Combine
@testable import AITherapist

//class ConversationServiceTests: XCTestCase {
//    let appState = CurrentValueSubject<AppState, Never>(AppState())
//    var mockedWebRepo: MockedConversationWebRepository!
//    var mockedDBRepo: MockedConversationDBRepository!
//    var sut: MainConversationService
//    var subscriptions = Set<AnyCancellable>()
//    var chatService: MainChatService
//    
//    
//    override func setUp() {
//        appState.value = AppState()
//        mockedWebRepo = MockedConversationWebRepository()
//        mockedDBRepo = MockedConversationDBRepository()
//
//        sut = MainConversationService(conversationRepository: mockedWebRepo, appState: appState, conversationDBRepository: mockedDBRepo, chatService: chatService)
//    }
//
//    override func tearDown() {
//        subscriptions = Set<AnyCancellable>()
//    }
//}

//final class LoadJournalsTests: JournalServiceTests {
//    func test_emptyDB_successfulRequest_successfulStoring() {
//        let list = Journal.mockedJournals
//        
//        // Configuring expected actions on repositories
//        
//        mockedWebRepo.actions = .init(expected: [
//            .loadJournalList
//        ])
//        mockedDBRepo.actions = .init(expected: [
//            .loadJournals,
//            .storeJournal(journal: list.first!, fromServer: true),
//        ])
//        
//        // Configuring responses from repositories
//        
//        mockedWebRepo.loadJournalListRespose = .success(list)
//        mockedDBRepo.loadJournalsResult = .success(list.lazyList)
//        mockedDBRepo.storeJournalResult = .success(())
//        
//        let journals = BindingWithPublisher(value: Loadable<[Journal]>.notRequested)
//        sut.loadJournalList(journals: journals.binding)
//        let exp = XCTestExpectation(description: #function)
//        journals.updatesRecorder.sink { updates in
//            XCTAssertEqual(updates, [
//                .notRequested,
//                .isLoading(last: nil, cancelBag: CancelBag()),
//                .loaded(list)
//            ], removing: Journal.prefixes)
//            self.mockedWebRepo.verify()
//            self.mockedDBRepo.verify()
//            exp.fulfill()
//        }.store(in: &subscriptions)
////        wait(for: [exp], timeout: 2)
//    }
//    
//}
//
//extension Journal: PrefixRemovable { }
