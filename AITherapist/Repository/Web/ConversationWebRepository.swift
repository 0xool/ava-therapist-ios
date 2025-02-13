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
    func loadConversationList() -> AnyPublisher<[Conversation], ServerError>
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Conversation, ServerError>
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, ServerError>
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
    
    func loadConversationList() -> AnyPublisher<[Conversation], ServerError> {
        
        let request: AnyPublisher<ConversationsResponse, ServerError> =
        webRequest(api: API.getConversationList)
        
        return request
            .map{ $0.data }
            .eraseToAnyPublisher()
    }
    
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Conversation, ServerError> {
        do {
            let parameters = try JSONEncoder().encode(data)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddConversationResponse, ServerError> = webRequest(api: API.addConversation(params: params))
            
            return request
                .map{ $0.data }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ServerError(message: "Data not in correct format", code: nil, clientError: .serializationError)).eraseToAnyPublisher()
        }
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, ServerError>{
        let request: AnyPublisher<DeleteConversationResponse, ServerError> = webRequest(api: API.deleteConversation(conversationID: conversationID))
        
        return request
            .map{ _ in }
            .eraseToAnyPublisher()
    }
}

extension MainConversationWebRepository {
    
    enum API: APICall{
        case getConversationList
        case addConversation(params: Parameters? = nil)
        case deleteConversation(conversationID: Int)
        
        var url: String {
            switch self {
            case .getConversationList:
                return "\(MainConversationWebRepository.ConversationAPI)/getConversationList"
            case .addConversation:
                return "\(MainConversationWebRepository.ConversationAPI)/addConversation"
            case let .deleteConversation(conversationID):
                return "\(MainConversationWebRepository.ConversationAPI)/deleteConversation/\(conversationID)"
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
                return JSONEncoding.default
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
