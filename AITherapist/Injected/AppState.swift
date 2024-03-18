//
//  AppState.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/2/23.
//


import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData.shared
    var routing = ViewRouting()
    var system = System()
    
    var permissions = Permissions()
    var conversationData = ConversationData()
    var application = Application.instance
}

extension AppState {
    class UserData: Equatable, ObservableObject{
        static func == (lhs: AppState.UserData, rhs: AppState.UserData) -> Bool {
            lhs.user == rhs.user
        }
        
        static let shared = UserData()
        
        @Published var user: Loadable<User> = .notRequested
        @Published var insight: Loadable<Insight> = .notRequested
        var setting: Loadable<Setting> = .notRequested
                
        func logout() {
            self.user = .notRequested
            self.setting = .notRequested
            self.insight = .notRequested
            
            _ = MainUserDBRepository().deleteUser()
            PersistentManager.DeleteUserToken()
            DataBaseManager.Instance.ClearAllData()
        }
    }
}

extension AppState{
    class ConversationData: ObservableObject{
        @Published var conversations: Loadable<LazyList<Conversation>> = .notRequested
        
        init(conversations: Loadable<LazyList<Conversation>> = .notRequested) {
            self.conversations = conversations
        }
    }
}

extension AppState{
    class Application: ObservableObject{
        @Published var showNewChat = false
        
        static let instance = Application()
        
        init(showNewChat: Bool = false) {
            self.showNewChat = showNewChat
        }
    }
}

extension AppState {
    struct ViewRouting: Equatable {
//        var user = User.R
//        var countriesList = CountriesList.Routing()
//        var countryDetails = CountryDetails.Routing()
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

extension AppState {
    struct Permissions: Equatable {
        var push: Permission.Status = .unknown
    }
    
    static func permissionKeyPath(for permission: Permission) -> WritableKeyPath<AppState, Permission.Status> {
        let pathToPermissions = \AppState.permissions
        switch permission {
        case .pushNotifications:
            return pathToPermissions.appending(path: \.push)
        }
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
        lhs.routing == rhs.routing &&
        lhs.system == rhs.system &&
        lhs.permissions == rhs.permissions
}

#if DEBUG
extension AppState {
    static var previews: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
}
#endif
