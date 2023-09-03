//
//  LoginViewModel.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/10/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    
    func login(username: String, password: String) {
        let params = ["username": username, "password": password]
        NetworkManager.SendRequest(decoderModel: AuthenticateMessage.self, params: params, successHandler: { res in
            
            guard let value = res.value else { return }
            // userHas Logged In
            
        }, failedHandler: { res in
            print(Constants.SendConversationUrl)
            print(res.error ?? "")
        }, url: Constants.SendConversationUrl)
    }
    
    func signUp(username: String, password: String){
        let params = ["username": username, "password": password]
        NetworkManager.SendRequest(decoderModel: AuthenticateMessage.self, params: params, successHandler: { res in
            
            guard let value = res.value else { return }
            // userHas Signed Up correctly In
            
        }, failedHandler: { res in
            print(Constants.SendConversationUrl)
            print(res.error ?? "")
        }, url: Constants.SendConversationUrl)
    }
    
    func setUserDefaults() {
        
    }
    
}
