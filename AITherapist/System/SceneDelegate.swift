//
//  SceneDelegate.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/2/23.
//


import UIKit
import SwiftUI
import Combine
import Foundation

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var systemEventsHandler: SystemEventsHandler?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let environment = AppEnvironment.bootstrap()
        let contentView = MainAppView(viewModel: .init(container: environment.container))
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        self.systemEventsHandler = environment.systemEventsHandler
        if !connectionOptions.urlContexts.isEmpty {
            systemEventsHandler?.sceneOpenURLContexts(connectionOptions.urlContexts)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        systemEventsHandler?.sceneOpenURLContexts(URLContexts)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        systemEventsHandler?.sceneDidBecomeActive()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        systemEventsHandler?.sceneWillResignActive()
    }
}

