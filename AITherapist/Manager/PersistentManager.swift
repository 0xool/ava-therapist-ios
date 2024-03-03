//
//  PersistentManager.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/11/23.
//

import Foundation
import KeychainSwift

class PersistentManager {
    static func UserHasFinishedOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: PersistentType.HasFinishedOnboarding.rawValue)
    }
    
    static func SaveUserToken(token: String) {
        // If token has been unverififed web call should invalidate it and get a new one
        if token.count == 0 { return }
        
        let keychain = KeychainSwift()
        keychain.set(token, forKey: PersistentType.UserCookie.rawValue)
    }

    static func DeleteUserToken() {
        let keychain = KeychainSwift()
        keychain.delete(PersistentType.UserCookie.rawValue)
    }
    
    static func GetUserToken() -> String {
        let keychain = KeychainSwift()
        let token = keychain.get(PersistentType.UserCookie.rawValue) ?? ""
        return token
    }
}

extension PersistentManager {
    enum PersistentType: String{
        case HasFinishedOnboarding = "HasFinishedOnboarding"
        case UserCookie = "JWT"
    }
}
