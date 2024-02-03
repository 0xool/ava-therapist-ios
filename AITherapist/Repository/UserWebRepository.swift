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
    func editUserInfo(username: String, name: String, lastName: String, userID: Int) -> AnyPublisher<Void, Error>
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
    
    func editUserInfo(username: String, name: String, lastName: String, userID: Int) -> AnyPublisher<Void, Error> {
        let request = EditUserInfoRequest(user: .init(username: username, name: name, lastName: lastName))
        
        do {
            let parameters = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<EditUserInfoResponse, Error> = webRequest(api: API.editUserInfo(params: params))
                        
            return request
                .map{ _ in }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
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
                return URLEncoding.default
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
