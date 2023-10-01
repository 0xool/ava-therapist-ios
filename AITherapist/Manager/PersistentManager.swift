//
//  PersistentManager.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/11/23.
//

import Foundation



class PersistentManager {
    static func UserHasFinishedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: PersistentType.HasFinishedOnboarding.rawValue)
    }
}

extension PersistentManager {
    enum PersistentType: String{
        case HasFinishedOnboarding = "HasFinishedOnboarding"
    }
    
}
