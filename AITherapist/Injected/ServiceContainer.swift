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
        
        init(conversationService: ConversationService, userPermissionsService: UserPermissionsService, authenticationService: AuthenticateService) {
            self.conversationService = conversationService
            self.userPermissionsService = userPermissionsService
            self.authenticationService = authenticationService
        }
        
        static var stub: Self {
            .init(conversationService: StubCountriesService(),
                  userPermissionsService: StubUserPermissionsService(), authenticationService: StubAuthenticateService())
        }
    }
}
