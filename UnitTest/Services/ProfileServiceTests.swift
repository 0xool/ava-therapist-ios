//
//  ProfileServiceTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/18/23.
//

import XCTest
import SwiftUI
import Combine
@testable import AITherapist

class ProfileServiceTests: XCTestCase {
    let appState = CurrentValueSubject<AppState, Never>(AppState())
//    var imagePersistenceRepository: MainImagePersistenceRepository
    var subscriptions = Set<AnyCancellable>()
    var sut: MainProfileService!
    
    override func setUp() {
        appState.value = AppState()
//        imagePersistenceRepository = MainImagePersistenceRepository()
        
//        sut = MainProfileService(imagePersistenceRepository: imagePersistenceRepository, appState: appState)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
}

