//
//  AuthenticateRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/4/23.
//

import Foundation
import Alamofire
import Combine

protocol AuthenticateWebRepository: WebRepository {
    func login(email: String, password: String) -> AnyPublisher<AuthenticateResponse, ServerError>
    func register(name: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<AuthenticateResponse, ServerError>
    func getUserInfo() -> AnyPublisher<GetUserInfoResponse, ServerError>
    
    func authenticateUserWithThirdParty(provider: String, token: String) -> AnyPublisher<AuthenticateResponse, ServerError>
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
    
    func login(email: String, password: String) -> AnyPublisher<AuthenticateResponse, ServerError> {
        let params = ["user": ["email" : email , "password" : password]]
        let request: AnyPublisher<AuthenticateResponse, ServerError> = webRequest(api: API.login(params: params))
        
        return request
                .eraseToAnyPublisher()
    }
    
    func getUserInfo() -> AnyPublisher<GetUserInfoResponse, ServerError> {
        let request: AnyPublisher<GetUserInfoResponse, ServerError> = webRequest(api: API.getUserInfo)
        
        return request
                .eraseToAnyPublisher()
    }
    
    func register(name: String, email: String, password: String, mobileNumber: String) -> AnyPublisher<AuthenticateResponse, ServerError> {
        let params = ["user": ["email" : email , "password" : password, "mobile": mobileNumber, "name": name]]
        let request: AnyPublisher<AuthenticateResponse, ServerError> = webRequest(api: API.register(params: params))
        
        return request
                .eraseToAnyPublisher()
    }
    
    func authenticateUserWithThirdParty(provider: String, token: String) -> AnyPublisher<AuthenticateResponse, ServerError>{
        let params = ["user": ["provider" : provider , "token" : token]]
        let request: AnyPublisher<AuthenticateResponse, ServerError> = webRequest(api: API.login(params: params))
        
        return request
                .eraseToAnyPublisher()
    }
}

extension MainAuthenticateWebRepository {
    enum API: APICall {
        case login(params: Parameters?)
        case register(params: Parameters?)
        case getUserInfo
        case thirdPartyAuth(params: Parameters?)
        
        var url: String {
            switch self {
            case .login:
                "\(MainAuthenticateWebRepository.AuthenticateAPI)/login"
            case .register:
                "\(MainAuthenticateWebRepository.AuthenticateAPI)/register"
            case .getUserInfo:
                "\(MainAuthenticateWebRepository.AuthenticateAPI)/getUserInfo"
            case .thirdPartyAuth:
                "\(MainAuthenticateWebRepository.AuthenticateAPI)/thirdPartyAuth"
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
            case .thirdPartyAuth:
                .post
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
            case .thirdPartyAuth:
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
            case let .thirdPartyAuth(params):
                params
            }
        }
    }
    
}

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
