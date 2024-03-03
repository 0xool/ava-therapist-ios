//
//  UserWebRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 1/22/24.
//

import Foundation
import Combine
import Alamofire

protocol UserWebRepository: WebRepository {
    func editUserInfo(username: String, name: String, lastname: String) -> AnyPublisher<Void, Error>
}

struct MainUserWebRepository: UserWebRepository {
    var AFSession: Session = .default
    
    var session: URLSession
    var baseURL: String
    var bgQueue: DispatchQueue = Constants.bgQueue
    
    static let UserAPI = "user"

    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.bgQueue = Constants.bgQueue
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func editUserInfo(username: String, name: String, lastname: String) -> AnyPublisher<Void, Error> {
        let requestParams: EditUserInfoRequest = EditUserInfoRequest(user: .init(username: username, name: name, lastname: lastname))
        
        do {
            let parameters = try JSONEncoder().encode(requestParams)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<EditUserInfoResponse, Error> = webRequest(api: API.editUserInfo(params: params))
            
            return request
                .map{ _ in }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
//    func editUserInfo(username: String, name: String, lastname: String) -> AnyPublisher<Void, Error> {
//        let requestParams = EditUserInfoRequest(user: .init(username: username, name: name, lastname: lastname))
//        
//        do {
//            let parameters = try JSONEncoder().encode(requestParams)
//            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
//            let request: AnyPublisher<EditUserInfoResponse, Error> = webRequest(api: API.editUserInfo(params: params))
//                        
//            return request
//                .map{ test in
//                    print(test)
//                }
//                .eraseToAnyPublisher()
//        } catch {
//            return Fail(error: error).eraseToAnyPublisher()
//        }
//    }
}

extension MainUserWebRepository {
    enum API: APICall {
        case editUserInfo(params: Parameters?)
        
        var url: String {
            switch self {
            case .editUserInfo:
                return "\(MainUserWebRepository.UserAPI)/updateUserInfo"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .editUserInfo:
                return .post
            }
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .editUserInfo:
                return JSONEncoding.default
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case let .editUserInfo(params):
                return params
            }
        }
    }
}
