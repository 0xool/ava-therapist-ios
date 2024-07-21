//
//  PersistentManager.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/11/23.
//

import Foundation
import KeychainSwift

class PersistentManager {
    static func userHasFinishedOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: PersistentType.HasFinishedOnboarding.rawValue)
    }
    
    static func saveUserToken(token: String) {
        // If token has been unverififed web call should invalidate it and get a new one
        if token.count == 0 { return }
        
        let keychain = KeychainSwift()
        keychain.set(token, forKey: PersistentType.UserCookie.rawValue)
    }

    static func deleteUserToken() {
        let keychain = KeychainSwift()
        keychain.delete(PersistentType.UserCookie.rawValue)
    }
    
    static func getUserToken() -> String {
        let keychain = KeychainSwift()
        let token = keychain.get(PersistentType.UserCookie.rawValue) ?? ""
        return token
    }
    
    static func getNotificationSeen() -> Bool {
        KeychainSwift().get(PersistentType.NotificationSeen.rawValue) == PersistentType.NotificationSeen.rawValue
    }
    
    static func saveNotificationSeen() {
        let keychain = KeychainSwift()
        keychain.set(PersistentType.NotificationSeen.rawValue, forKey: PersistentType.NotificationSeen.rawValue)
    }
}

extension PersistentManager {
    enum PersistentType: String{
        case HasFinishedOnboarding = "HasFinishedOnboarding"
        case NotificationSeen = "NotificationSeen"
        case UserCookie = "JWT"
    }
}
