//
//  AuthenticateRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/4/23.
//

import Foundation
import Combine

// Refactor this in both the backend and frontend to fix this respose setup
struct AuthenticateResponse: Decodable {
    var message: String
    var code: Int
    var auth: Bool
    let token: String
    let id: Int
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case message = "message"
//        case code = "code"
//        case auth = "auth"
//        case token = "token"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.message = try container.decode(String.self, forKey: .message)
//        self.code = try container.decode(String.self, forKey: .code)
//        self.auth = try container.decode(String.self, forKey: .auth)
//        self.token = try container.decode(String.self, forKey: .token)
//        self.id = try container.decode(Int.self, forKey: .id)
//    }
}

protocol AuthenticateRepository: WebRepository {
    func login(email: String, password: String) -> AnyPublisher<User, Error>
    func register(email: String, password: String) -> AnyPublisher<User, Error>
}

struct MainAuthenticateRepository: AuthenticateRepository {
    var baseURL: String
    let AuthenticateAPI = "user/"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        let params = ["user": ["username" : email , "password" : password]]
        let request: AnyPublisher<AuthenticateResponse, Error> = SendRequest(pathVariable: nil, params: params, url: getPath(api: .login))
        
        // Refactor this code to remove setting variables inside this call back
        return request.map { (response) -> User in
            let token = response.token
            let id = response.id
            self.SetCookie(cookie: token)
            return User(id: id, token: token)
        }.eraseToAnyPublisher()
    }
    
    func register(email: String, password: String) -> AnyPublisher<User, Error> {
        let params = ["email" : email , "password" : password]
        return SendRequest(pathVariable: nil, params: params, url: getPath(api: .register))
    }
}

extension MainAuthenticateRepository {
    enum API: String {
        case login = "login"
        case register = "register/"
    }
    
    func getPath(api: API) -> String {
        switch api {
        case .login:
            return "\(baseURL)\(AuthenticateAPI)\(api.rawValue)"
        case .register:
            return "\(baseURL)\(AuthenticateAPI)\(api.rawValue)"
        }
    }
    
}
