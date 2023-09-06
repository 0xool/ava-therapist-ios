//
//  InteractorsContainer.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import UIKit

extension DIContainer {
    struct Services {
        let conversationService: ConversationService
//        let imagesService: ImagesService
        let userPermissionsService: UserPermissionsService
        
        init(conversationService: ConversationService, userPermissionsService: UserPermissionsService) {
            self.conversationService = conversationService
            self.userPermissionsService = userPermissionsService
        }
        
        static var stub: Self {
            .init(conversationService: StubCountriesService(),
                  userPermissionsService: StubUserPermissionsService())
        }
    }
}
