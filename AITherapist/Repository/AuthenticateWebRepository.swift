//
//  AuthenticateRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/4/23.
//

import Foundation
import Alamofire
import Combine

// Refactor this in both backend and frontend to fix this respose setup
struct AuthenticateResponse: ServerResponse{
    var message: String?
    var code: Int?
    var data: AuthenticateResponseData

    struct AuthenticateResponseData: Decodable {
        var auth: Bool
        let token: String
        let id: Int
        let user: User
    }
}

protocol AuthenticateWebRepository: WebRepository {
    func login(email: String, password: String) -> AnyPublisher<User, Error>
    func register(nickname: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<User, Error>
}

struct MainAuthenticateWebRepository: AuthenticateWebRepository {
    var AFSession: Session
    
    var session: URLSession
    var baseURL: String
    var bgQueue: DispatchQueue = Constants.bgQueue
    
    static let AuthenticateAPI = "user"

    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        let params = ["user": ["email" : email , "password" : password]]
        let request: AnyPublisher<AuthenticateResponse, Error> = webRequest(api: API.login(params: params))
        
        // Refactor this code to remove setting variables inside this call back
        return request.map { (response) -> User in
            let token = response.data.token
            self.SetCookie(cookie: token)
            return response.data.user
        }
        .eraseToAnyPublisher()
    }
    
    func register(nickname: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<User, Error> {
        let params = ["user": ["email" : email , "password" : password, "mobile": mobileNumber, "nickname": nickname]]
        let request: AnyPublisher<AuthenticateResponse, Error> = webRequest(api: API.register(params: params))
        
        // Refactor this code to remove setting variables inside this call back
        return request.map { (response) -> User in
            let token = response.data.token
            self.SetCookie(cookie: token)
            return response.data.user
        }
        .eraseToAnyPublisher()
    }
}

extension MainAuthenticateWebRepository {
    
    enum API: APICall {
        case login(params: Parameters?)
        case register(params: Parameters?)
        
        var url: String {
            switch self {
            case .login:
                return "\(MainAuthenticateWebRepository.AuthenticateAPI)/login"
            case .register:
                return "\(MainAuthenticateWebRepository.AuthenticateAPI)/register"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .login:
                return .post
            case .register:
                return .post
            }
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .login:
                return JSONEncoding.default
            case .register:
                return JSONEncoding.default
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case let .login(params):
                return params
            case let .register(params):
                return params
            }
        }
    }
    
}
