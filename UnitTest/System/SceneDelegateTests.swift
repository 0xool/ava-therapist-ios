//
//  SceneDelegateTests.swift
//  UnitTests
//
//  Created by Cyrus Refahi on 10/6/23.
//  Copyright © 2020 Cyrus Refahi. All rights reserved.
//

import XCTest
import UIKit
@testable import AITherapist

final class SceneDelegateTests: XCTestCase {
    
    private lazy var scene: UIScene = {
        UIApplication.shared.connectedScenes.first!
    }()
    
    func test_openURLContexts() {
        let sut = SceneDelegate()
        let eventsHandler = MockedSystemEventsHandler(expected: [
            .openURL
        ])
        sut.systemEventsHandler = eventsHandler
        sut.scene(scene, openURLContexts: .init())
        eventsHandler.verify()
    }
    
    func test_didBecomeActive() {
        let sut = SceneDelegate()
        let eventsHandler = MockedSystemEventsHandler(expected: [
            .becomeActive
        ])
        sut.systemEventsHandler = eventsHandler
        sut.sceneDidBecomeActive(scene)
        eventsHandler.verify()
    }
    
    func test_willResignActive() {
        let sut = SceneDelegate()
        let eventsHandler = MockedSystemEventsHandler(expected: [
            .resignActive
        ])
        sut.systemEventsHandler = eventsHandler
        sut.sceneWillResignActive(scene)
        eventsHandler.verify()
    }
}
