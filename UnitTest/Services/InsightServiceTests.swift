//
//  InsightServiceTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/18/23.
//

import XCTest
import SwiftUI
import Combine
@testable import AITherapist

class InsightServiceTests: XCTestCase {
    let appState = CurrentValueSubject<AppState, Never>(AppState())
    var mockedWebRepo: MockedInsightWebRepository!
    var mockedDBRepo: MockedInsightDBRepository!
    var subscriptions = Set<AnyCancellable>()
    var sut: MainInsightService!
    
    
    override func setUp() {
        appState.value = AppState()
        mockedWebRepo = MockedInsightWebRepository()
        mockedDBRepo = MockedInsightDBRepository()
        sut = MainInsightService(insightRepository: mockedWebRepo, appState: appState, insightDBRepository: mockedDBRepo)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
}
