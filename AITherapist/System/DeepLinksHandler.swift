//
//  DeepLinksHandler.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/5/23.
//

import Foundation

enum DeepLink: Equatable {
    
    case showInsight
    
    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            components.host == "www.example.com",
            let query = components.queryItems
        else { return nil }
        
        print(query)
        return nil
    }
}

// MARK: - DeepLinksHandler

protocol DeepLinksHandler {
    func open(deepLink: DeepLink)
}

struct MainDeepLinksHandler: DeepLinksHandler {
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func open(deepLink: DeepLink) {
        switch deepLink {
        case .showInsight:
            let routeToDestination = {
//                self.container.appState.bulkUpdate {
//                    $0.routing.countriesList.countryDetails = alpha3Code
//                    $0.routing.countryDetails.detailsSheet = true
//                }
            }
            /*
             SwiftUI is unable to perform complex navigation involving
             simultaneous dismissal or older screens and presenting new ones.
             A work around is to perform the navigation in two steps:
             */
            let defaultRouting = AppState.ViewRouting()
            if container.appState.value.routing != defaultRouting {
                self.container.appState[\.routing] = defaultRouting
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: routeToDestination)
            } else {
                routeToDestination()
            }
        }
    }
}
