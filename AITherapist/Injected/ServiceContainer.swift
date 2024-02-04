//
//  InteractorsContainer.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/2/23.
//

import SwiftUI

extension DIContainer {
    struct Services {
        let conversationService: ConversationService
        let userPermissionsService: UserPermissionsService
        let authenticationService: AuthenticationService
        
        let insightService: InsightService
        let chatService: ChatService
        let journalService: JournalService
        
        let profileService: ProfileService
        let settingService: SettingService
        
        init(services: ServiceRepository) {
            self.conversationService = services.conversationService
            self.userPermissionsService = services.userPermissionsService
            self.authenticationService = services.authenticationService
            
            self.insightService = services.insightService
            self.chatService = services.chatService
            self.journalService = services.journalService
            
            self.profileService = services.profileService
            self.settingService = services.settingService
        }
        
        static var stub: Self {
            .init(services: .init(
                conversationService: StubConversationService(),
                  userPermissionsService: StubUserPermissionsService(), authenticationService: StubAuthenticateService(), insightService: StubInsightService(), chatService: StubChatService(), journalService: StubJournalService(), profileService:  StubProfileService(), settingService: StubSettingService()))
        }
    }
    
    struct ServiceRepository {
        let conversationService: ConversationService
        let userPermissionsService: UserPermissionsService
        let authenticationService: AuthenticationService
        
        let insightService: InsightService
        let chatService: ChatService
        let journalService: JournalService
        
        let profileService: ProfileService
        let settingService: SettingService
    }
}
