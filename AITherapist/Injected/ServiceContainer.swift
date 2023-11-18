//
//  InteractorsContainer.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import SwiftUI

extension DIContainer {
    struct Services {
        let conversationService: ConversationService
        let userPermissionsService: UserPermissionsService
        let authenticationService: AuthenticateService
        
        let insightService: InsightService
        let chatService: ChatService
        let journalService: JournalService
        
        init(conversationService: ConversationService, userPermissionsService: UserPermissionsService, authenticationService: AuthenticateService, insightService: InsightService, chatService: ChatService, journalService: JournalService) {
            self.conversationService = conversationService
            self.userPermissionsService = userPermissionsService
            self.authenticationService = authenticationService
            
            self.insightService = insightService
            self.chatService = chatService
            self.journalService = journalService
        }
        
        static var stub: Self {
            .init(conversationService: StubConversationService(),
                  userPermissionsService: StubUserPermissionsService(), authenticationService: StubAuthenticateService(), insightService: StubInsightService(), chatService: StubChatService(), journalService: StubJournalService())
        }
    }
}
