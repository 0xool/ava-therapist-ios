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
        let userSetting: Setting
    }
}

struct GetUserInfoResponse: ServerResponse{
    var message: String?
    var code: Int?
    var data: GetUserInfoResponseData

    struct GetUserInfoResponseData: Decodable {
        let user: User
        let userSetting: Setting
    }
}

protocol AuthenticateWebRepository: WebRepository {
    func login(email: String, password: String) -> AnyPublisher<AuthenticateResponse, Error>
    func register(nickname: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<AuthenticateResponse, Error>
    func getUserInfo() -> AnyPublisher<GetUserInfoResponse, Error>
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
    
    func login(email: String, password: String) -> AnyPublisher<AuthenticateResponse, Error> {
        let params = ["user": ["email" : email , "password" : password]]
        let request: AnyPublisher<AuthenticateResponse, Error> = webRequest(api: API.login(params: params))
        
        return request
                .eraseToAnyPublisher()
    }
    
    func getUserInfo() -> AnyPublisher<GetUserInfoResponse, Error> {
        let request: AnyPublisher<GetUserInfoResponse, Error> = webRequest(api: API.getUserInfo)
        
        return request
                .eraseToAnyPublisher()
    }
    
    func register(nickname: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<AuthenticateResponse, Error> {
        let params = ["user": ["email" : email , "password" : password, "mobile": mobileNumber, "nickname": nickname]]
        let request: AnyPublisher<AuthenticateResponse, Error> = webRequest(api: API.register(params: params))
        
        return request
                .eraseToAnyPublisher()
    }
}

extension MainAuthenticateWebRepository {
    
    enum API: APICall {
        case login(params: Parameters?)
        case register(params: Parameters?)
        case getUserInfo
        
        var url: String {
            switch self {
            case .login:
                "\(MainAuthenticateWebRepository.AuthenticateAPI)/login"
            case .register:
                "\(MainAuthenticateWebRepository.AuthenticateAPI)/register"
            case .getUserInfo:
                "\(MainAuthenticateWebRepository.AuthenticateAPI)/getUserInfo"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .login:
                .post
            case .register:
                .post
            case .getUserInfo:
                .get
            }
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .login:
                JSONEncoding.default
            case .register:
                JSONEncoding.default
            case .getUserInfo:
                JSONEncoding.default
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case let .login(params):
                params
            case let .register(params):
                params
            case .getUserInfo:
                nil
            }
        }
    }
    
}
