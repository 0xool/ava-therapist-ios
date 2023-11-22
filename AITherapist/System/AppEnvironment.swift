//
//  AppEnvironment.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
    let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        /*
         To see the deep linking in action:
         
         1. Launch the app in iOS 13.4 simulator (or newer)
         2. Subscribe on Push Notifications with "Allow Push" button
         3. Minimize the app
         4. Drag & drop "push_with_deeplink.apns" into the Simulator window
         5. Tap on the push notification
         
         Alternatively, just copy the code below before the "return" and launch:
         
            DispatchQueue.main.async {
                deepLinksHandler.open(deepLink: .showCountryFlag(alpha3Code: "AFG"))
            }
        */
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let dbRepositories = configuredDBRepositories(appState: appState)
        let services = configuredServices(appState: appState,
                                                dbRepositories: dbRepositories,
                                                webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, services: services)
        let deepLinksHandler = MainDeepLinksHandler(container: diContainer)
        let pushNotificationsHandler = MainPushNotificationsHandler(deepLinksHandler: deepLinksHandler)
        let systemEventsHandler = MainSystemEventsHandler(
            container: diContainer, deepLinksHandler: deepLinksHandler,
            pushNotificationsHandler: pushNotificationsHandler,
            pushTokenWebRepository: webRepositories.pushTokenWebRepository)
        
        return AppEnvironment(container: diContainer,
                              systemEventsHandler: systemEventsHandler)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }

    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let baseURL: String = Constants.MainUrl
//        let countriesWebRepository = RealCountriesWebRepository(
//            session: session,
//            baseURL: "https://restcountries.com/v2")
//        let imageWebRepository = RealImageWebRepository(
//            session: session,
//            baseURL: "https://ezgif.com")
        
        let authenticationWebRepository = MainAuthenticateRepository(baseURL: baseURL)
        let pushTokenWebRepository = RealPushTokenWebRepository(
            session: session,
            baseURL: "https://fake.backend.com")
        let conversationWebRepository = MainConversationRepository(baseURL: baseURL)
        let insightWebRepository = MainIsightRepository(baseURL: baseURL)
        let chatWebRepoistory = MainChatRepository(baseURL: baseURL)
        
        let journalWebRepository = MainJournalRepository(baseURL: baseURL)
        
        return .init(conversationRepository: conversationWebRepository, pushTokenWebRepository: pushTokenWebRepository, authenticationRepository: authenticationWebRepository, insightRepository: insightWebRepository, chatRepository: chatWebRepoistory, journalRepository: journalWebRepository)
    }
    
    private static func configuredDBRepositories(appState: Store<AppState>) -> DIContainer.DBRepositories {
        let conversationDBRepository = MainConversationDBRepository()
        let userDBRepository = MainUserDBRepository()
        let insightDBRepository = MainInsightDBRepository()
        
        let chatDBRepository = MainChatDBRepository()
        let journalDBRepository = MainJournalDBRepository()
        
        return .init(conversationRepository: conversationDBRepository, userRepository: userDBRepository, insightRepository: insightDBRepository, chatRepository: chatDBRepository, journalRepository: journalDBRepository)
    }
    
    private static func configuredServices(appState: Store<AppState>,
                                           dbRepositories: DIContainer.DBRepositories,
                                           webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Services {

        let insightService = MainInsightService(insightRepository: webRepositories.insightRepository, appState: appState, conversationDBRepository: dbRepositories.insightRepository)
        let authenticationService = MainAuthenticateService(appState: appState, authenticateRepository: webRepositories.authenticationRepository, userDBRepository: dbRepositories.userRepository)
        let chatService = MainChatService(chatRepository: webRepositories.chatRepository, appState: appState, chatDBRepository: dbRepositories.chatRepository)
        let conversationService = MainConversationService(conversationRepository: webRepositories.conversationRepository, appState: appState, conversationDBRepository: dbRepositories.conversationRepository, chatService: chatService)
        let journalService = MainJournalService(journalRepository: webRepositories.journalRepository, journalDBRepository: dbRepositories.journalRepository, appState: appState)
        let userPermissionsService = MainUserPermissionsService(
            appState: appState, openAppSettings: {
                URL(string: UIApplication.openSettingsURLString).flatMap {
                    UIApplication.shared.open($0, options: [:], completionHandler: nil)
                }
            })
        
        return .init(conversationService: conversationService, userPermissionsService: userPermissionsService, authenticationService: authenticationService, insightService: insightService, chatService: chatService, journalService: journalService)
    }
}

extension DIContainer {
    struct WebRepositories {
//        let imageRepository: ImageWebRepository
        let conversationRepository: ConversationRepository
        let pushTokenWebRepository: PushTokenWebRepository
        let authenticationRepository: AuthenticateRepository
        
        let insightRepository: InsightRepository
        let chatRepository: ChatRepository
        let journalRepository: JournalRepository
    }

    struct DBRepositories {
        let conversationRepository: ConversationDBRepository
        let userRepository: UserDBRepository
        let insightRepository: InsightDBRepository
        let chatRepository: ChatDBRepository
        let journalRepository: JournalDBRepository
    }
}
