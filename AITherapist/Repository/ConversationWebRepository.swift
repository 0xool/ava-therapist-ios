//
//  ConversationRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/4/23.
//

import Foundation
import Combine

protocol ConversationWebRepository: WebRepository {
    func loadConversationList() -> AnyPublisher<[Conversation], Error>
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Conversation, Error>
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>
}

struct MainConversationWebRepository: ConversationWebRepository {
    
    var baseURL: String
    let ConversationAPI = "conversation"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadConversationList() -> AnyPublisher<[Conversation], Error> {
        
        let request: AnyPublisher<ConversationsResponse, Error> = WebRequest(pathVariable: nil, params: nil, url: getPath(api: .allConversations), method: .get)
        
        return request
            .map{
                return $0.data
            }
            .eraseToAnyPublisher()
    }
    
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Conversation, Error> {
        let url = getPath(api: .addConversation)
        do {
            let parameters = try JSONEncoder().encode(data)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddConversationResponse, Error> = WebRequest(pathVariable: nil, params: params, url: url, method: .post)
            
            return request
                .map{ $0.data }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>{
        let url = getPath(api: .deleteConversation, conversationID: conversationID)
        
        let request: AnyPublisher<DeleteConversationResponse, Error> = WebRequest(pathVariable: nil, params: nil, url: url, method: .delete)
            
        return request
            .map{ _ in
                
            }
            .eraseToAnyPublisher()
    }
}

extension MainConversationWebRepository {
    
    enum API: String {
        case allConversations = "getConversationList"
        case addConversation = "addConversation"
        case deleteConversation = "deleteConversation"
    }
    
    func getPath(api: API, conversationID: Int? = nil) -> String {
        let mainUrl = "\(baseURL)\(ConversationAPI)/\(api.rawValue)"
        switch api {
        case .addConversation:
            return mainUrl
        case .allConversations:
            return mainUrl
        case .deleteConversation:
            guard let id = conversationID else {
                return mainUrl
            }
            
            return "\(mainUrl)/\(id)"
        }
    }
}
