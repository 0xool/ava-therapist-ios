//
//  SettingWebRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/3/24.
//

import Foundation
import Combine
import Alamofire

protocol SettingWebRepository: WebRepository {
    func editSettingInfo(setting: Setting) -> AnyPublisher<Void, ServerError>
    func getAllPersona() -> AnyPublisher<[Persona], ServerError>
}

struct MainSettingWebRepository: SettingWebRepository {
    var AFSession: Session = .default
    
    var session: URLSession
    var baseURL: String
    var bgQueue: DispatchQueue = Constants.bgQueue
    
    static let SettingAPI = "setting"
    
    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.bgQueue = Constants.bgQueue
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
 
    
    func editSettingInfo(setting: Setting) -> AnyPublisher<Void, ServerError>
    {
        let request = UpdateSettingRequest(setting: setting)
        
        do {
            let parameters = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<UpdateSettingResponse, ServerError> = webRequest(api: API.updateSetting(params: params))
                        
            return request
                .map{ _ in }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ServerError()).eraseToAnyPublisher()
        }
    }
    
    func getAllPersona() -> AnyPublisher<[Persona], ServerError>{
        let request: AnyPublisher<GetAllPersonaResponse, ServerError> =
        webRequest(api: API.getAllPersona)
        
        return request
            .map{ $0.data }
            .eraseToAnyPublisher()
    }
}

extension MainSettingWebRepository {
    enum API: APICall {
        case getAllPersona
        case updateSetting(params: Parameters?)
        
        var url: String {
            switch self {
            case .getAllPersona:
                return "\(MainSettingWebRepository.SettingAPI)/getAllPersona"
            case .updateSetting:
                return "\(MainSettingWebRepository.SettingAPI)/updateSetting"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getAllPersona:
                return .get
            case .updateSetting:
                return .post
            }
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .getAllPersona:
                return URLEncoding.default
            case .updateSetting:
                return JSONEncoding.default
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case .getAllPersona:
                return nil
            case let .updateSetting(params):
                return params
            }
        }
    }
}


