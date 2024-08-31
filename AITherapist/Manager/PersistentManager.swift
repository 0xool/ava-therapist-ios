//
//  PersistentManager.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/11/23.
//

import Foundation
import KeychainSwift

class PersistentManager {
    
    let keychain = KeychainSwift()
    static let instance = PersistentManager()
    
    init() {
        keychain.synchronizable = true
    }
    
    func userHasFinishedOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: PersistentType.HasFinishedOnboarding.rawValue)
    }
    
    func saveUserCookieToken(token: String) {
        if token.count == 0 { return }
        
        keychain.set(token, forKey: PersistentType.UserCookieToken.rawValue)
    }

    func deleteUserCookieToken() {
        keychain.delete(PersistentType.UserCookieToken.rawValue)
    }
    
    func getUserCookieToken() -> String {
        let token = keychain.get(PersistentType.UserCookieToken.rawValue) ?? ""
        return token
    }
    
    func saveUserAuthToken(token: String) {
        if token.count == 0 { return }
        
        keychain.set(token, forKey: PersistentType.UserAuthToken.rawValue)
    }

    func deleteUserAuthToken() {
        keychain.delete(PersistentType.UserAuthToken.rawValue)
    }
    
    func getUserAuthToken() -> String {
        let token = keychain.get(PersistentType.UserAuthToken.rawValue) ?? ""
        return token
    }
    
    func getNotificationSeen() -> Bool {
        keychain.get(PersistentType.NotificationSeen.rawValue) == PersistentType.NotificationSeen.rawValue
    }
    
    func saveNotificationSeen() {
        keychain.set(PersistentType.NotificationSeen.rawValue, forKey: PersistentType.NotificationSeen.rawValue)
    }
}

extension PersistentManager {
    enum PersistentType: String{
        case HasFinishedOnboarding = "HasFinishedOnboarding"
        case NotificationSeen = "NotificationSeen"
        case UserCookieToken = "CookieJWT"
        case UserAuthToken = "AuthJWT"
    }
}
