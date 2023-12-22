//
//  ChatServiceTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/18/23.
//

import XCTest
import SwiftUI
import Combine
@testable import AITherapist

class ChatServiceTests: XCTestCase {
    let appState = CurrentValueSubject<AppState, Never>(AppState())
    var mockedWebRepo: MockedChatWebRepository!
    var mockedDBRepo: MockedChatDBRepository!
    var subscriptions = Set<AnyCancellable>()
    var sut: MainChatService!
    
    
    override func setUp() {
        appState.value = AppState()
        mockedWebRepo = MockedChatWebRepository()
        mockedDBRepo = MockedChatDBRepository()
        sut = MainChatService(chatRepository: mockedWebRepo, appState: appState, chatDBRepository: mockedDBRepo)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
}
