//
//  ConversationRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/4/23.
//

import Foundation
import Alamofire
import Combine

protocol ConversationWebRepository: WebRepository {
    func loadConversationList() -> AnyPublisher<[Conversation], Error>
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Conversation, Error>
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>
}

struct MainConversationWebRepository: ConversationWebRepository {
    var AFSession: Session = .default
    
    var session: URLSession
    var baseURL: String
    var bgQueue: DispatchQueue = Constants.bgQueue
    
    static let ConversationAPI = "conversation"
    
    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.bgQueue = Constants.bgQueue
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func loadConversationList() -> AnyPublisher<[Conversation], Error> {
        
        let request: AnyPublisher<ConversationsResponse, Error> =
        webRequest(api: API.getConversationList)
        
        return request
            .map{
                return $0.data
            }
            .eraseToAnyPublisher()
    }
    
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Conversation, Error> {
        do {
            let parameters = try JSONEncoder().encode(data)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddConversationResponse, Error> = webRequest(api: API.addConversation(params: params))
            
            return request
                .map{ $0.data }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>{
        let request: AnyPublisher<DeleteConversationResponse, Error> = webRequest(api: API.deleteConversation)
        
        return request
            .map{ _ in
                
            }
            .eraseToAnyPublisher()
    }
}

extension MainConversationWebRepository {
    
    enum API: APICall{
        case getConversationList
        case addConversation(params: Parameters? = nil)
        case deleteConversation
        
        var url: String {
            switch self {
            case .getConversationList:
                return "\(MainConversationWebRepository.ConversationAPI)/getConversationList"
            case .addConversation:
                return "\(MainConversationWebRepository.ConversationAPI)/addConversation"
            case .deleteConversation:
                return "\(MainConversationWebRepository.ConversationAPI)/deleteConversation"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getConversationList:
                return .get
            case .addConversation:
                return .post
            case .deleteConversation:
                return .delete
            }
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .getConversationList:
                return URLEncoding.default
            case .addConversation:
                return JSONEncoding.default
            case .deleteConversation:
                return URLEncoding.default
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case .getConversationList:
                return nil
            case let .addConversation(params):
                return params
            case .deleteConversation:
                return nil
            }
        }
    }
}
