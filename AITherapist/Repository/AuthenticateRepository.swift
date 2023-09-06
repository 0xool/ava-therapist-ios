//
//  AuthenticateRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/4/23.
//

import Foundation
import Combine

struct AuthenticateResponse: Decodable {
    let token: String
    let user: User
}

protocol AuthenticateRepository: WebRepository {
    func login(email: String, password: String) -> AnyPublisher<AuthenticateResponse, Error>
    func register(email: String, password: String) -> AnyPublisher<AuthenticateResponse, Error>
}

struct MainAuthenticateRepository: AuthenticateRepository {
    var baseURL: String
    let AuthenticateAPI = "user"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func login(email: String, password: String) -> AnyPublisher<AuthenticateResponse, Error> {
        let params = ["email" : email , "password" : password]
        return SendRequest(pathVariable: nil, params: params, url: getPath(api: .login))
    }
    
    func register(email: String, password: String) -> AnyPublisher<AuthenticateResponse, Error> {
        let params = ["email" : email , "password" : password]
        return SendRequest(pathVariable: nil, params: params, url: getPath(api: .register))
    }
    
}

extension MainAuthenticateRepository {
    
    enum API: String {
        case login = "login"
        case register = "register"
    }
    
    func getPath(api: API) -> String {
        switch api {
        case .login:
            return "\(AuthenticateAPI)/\(api.rawValue)"
        case .register:
            return "\(AuthenticateAPI)/\(api.rawValue)"
        }
    }
    
}
