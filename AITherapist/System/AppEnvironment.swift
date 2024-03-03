//
//  AppEnvironment.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/2/23.
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
        let persistenceRepositories = configurePersistenceRepositories(app: appState)
        
        let services = configuredServices(appState: appState,
                                                dbRepositories: dbRepositories,
                                          webRepositories: webRepositories, persistenceRepositories: persistenceRepositories)
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
        
//        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        let cookieProps = [
            HTTPCookiePropertyKey.domain: Constants.BaseUrl,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "jwt",
            HTTPCookiePropertyKey.value: PersistentManager.GetUserToken()
        ]
        
        if let cookie = HTTPCookie(properties: cookieProps) {
            configuration.httpCookieStorage?.setCookie(cookie)
        }
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }

    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let baseURL: String = Constants.MainUrl
        let authenticationWebRepository = MainAuthenticateWebRepository(baseURL: baseURL, session: session)
        let pushTokenWebRepository = RealPushTokenWebRepository(
            session: session,
            baseURL: "https://fake.backend.com")
        
        let conversationWebRepository = MainConversationWebRepository(baseURL: baseURL, session: session)
        let insightWebRepository = MainInsightWebRepository(session: session, baseURL: baseURL)
        let chatWebRepoistory = MainChatWebRepository(baseURL: baseURL, session: session)
        
        let journalWebRepository = MainJournalWebRepository(baseURL: baseURL, session: session)
        let userWebRepository = MainUserWebRepository(baseURL: baseURL, session: session)
        let settingWebRepository = MainSettingWebRepository(baseURL: baseURL, session: session)
        
        return .init(conversationRepository: conversationWebRepository, pushTokenWebRepository: pushTokenWebRepository, authenticationRepository: authenticationWebRepository, insightRepository: insightWebRepository, chatRepository: chatWebRepoistory, journalRepository: journalWebRepository, userRepository: userWebRepository, settingRepository: settingWebRepository)
    }
    
    private static func configuredDBRepositories(appState: Store<AppState>) -> DIContainer.DBRepositories {
        let conversationDBRepository = MainConversationDBRepository()
        let userDBRepository = MainUserDBRepository()
        let insightDBRepository = MainInsightDBRepository()
        
        let chatDBRepository = MainChatDBRepository()
        let journalDBRepository = MainJournalDBRepository()
        let settingDBRepository = MainSettingDBRepository()
        
        let activityDBRepository = MainActivityDBRepository()
        
        return .init(conversationRepository: conversationDBRepository, userRepository: userDBRepository, insightRepository: insightDBRepository, chatRepository: chatDBRepository, journalRepository: journalDBRepository, settingRepository: settingDBRepository, activityRepository: activityDBRepository)
    }
    
    private static func configurePersistenceRepositories(app: Store<AppState>) -> DIContainer.PersistenceRepositories {
        .init(imagePersistenceRepository: MainImagePersistenceRepository())
    }
    
    private static func configuredServices(appState: Store<AppState>,
                                           dbRepositories: DIContainer.DBRepositories,
                                           webRepositories: DIContainer.WebRepositories,
                                           persistenceRepositories: DIContainer.PersistenceRepositories
    ) -> DIContainer.Services {

        let insightService = MainInsightService(insightRepository: webRepositories.insightRepository, appState: appState, insightDBRepository: dbRepositories.insightRepository)
        let authenticationService = MainAuthenticationService(appState: appState, authenticateRepository: webRepositories.authenticationRepository, userDBRepository: dbRepositories.userRepository, settingDBRepository: dbRepositories.settingRepository)
        let chatService = MainChatService(chatRepository: webRepositories.chatRepository, appState: appState, chatDBRepository: dbRepositories.chatRepository)
        
        let conversationService = MainConversationService(conversationRepository: webRepositories.conversationRepository, appState: appState, conversationDBRepository: dbRepositories.conversationRepository, chatService: chatService)
        let journalService = MainJournalService(journalRepository: webRepositories.journalRepository, journalDBRepository: dbRepositories.journalRepository, appState: appState)
        let profileService = MainProfileService(imagePersistenceRepository: persistenceRepositories.imagePersistenceRepository, userWebRepository: webRepositories.userRepository, userDBRepository: dbRepositories.userRepository, appState: appState)
        
        let activityService = MainActivityService(activityDBRepository: dbRepositories.activityRepository, appState: appState)
        let settingService = MainSettingService(settingRepository: webRepositories.settingRepository, settingDBRepository: dbRepositories.settingRepository, appState: appState)

        let userPermissionsService = MainUserPermissionsService(
            appState: appState, openAppSettings: {
                URL(string: UIApplication.openSettingsURLString).flatMap {
                    UIApplication.shared.open($0, options: [:], completionHandler: nil)
                }
            })
        
        return .init(services: .init(conversationService: conversationService, userPermissionsService: userPermissionsService, authenticationService: authenticationService, insightService: insightService, chatService: chatService, journalService: journalService, profileService: profileService, settingService: settingService, activityService: activityService))
    }
}

extension DIContainer {
    struct WebRepositories {
        let conversationRepository: ConversationWebRepository
        let pushTokenWebRepository: PushTokenWebRepository
        let authenticationRepository: AuthenticateWebRepository
        
        let insightRepository: InsightWebRepository
        let chatRepository: ChatWebRepository
        let journalRepository: JournalWebRepository
        
        let userRepository: UserWebRepository
        let settingRepository: SettingWebRepository
    }

    struct DBRepositories {
        let conversationRepository: ConversationDBRepository
        let userRepository: UserDBRepository
        let insightRepository: InsightDBRepository
        
        let chatRepository: ChatDBRepository
        let journalRepository: JournalDBRepository
        let settingRepository: SettingDBRepository
        
        let activityRepository: ActivityDBRepository
    }
    
    struct PersistenceRepositories {
        let imagePersistenceRepository: ImagePersistenceRepository
    }
}
