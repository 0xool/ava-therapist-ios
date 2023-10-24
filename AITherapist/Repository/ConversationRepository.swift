//
//  ConversationRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/4/23.
//

import Foundation
import Combine

protocol ConversationRepository: WebRepository {
    func loadConversationList() -> AnyPublisher<[Conversation], Error>
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Void, Error>
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>
//    func loadConversationChat(conversation: Conversation) -> AnyPublisher<[Message], Error>
}

struct MainConversationRepository: ConversationRepository {
    
    var baseURL: String
    let ConversationAPI = "conversation"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadConversationList() -> AnyPublisher<[Conversation], Error> {
        
        let request: AnyPublisher<ConversationsResponse, Error> = GetRequest(pathVariable: nil, params: nil, url: getPath(api: .allConversations))
        
        return request
            .map{
                return $0.conversations
            }
            .eraseToAnyPublisher()
    }
    
    func addConversation(data: AddConversationRequest) -> AnyPublisher<Void, Error> {
        let url = getPath(api: .addConversation)
        do {
            let parameters = try JSONEncoder().encode(data)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddConversationResponse, Error> = SendRequest(pathVariable: nil, params: params, url: url)
            return request
                .map{ _ in
                    
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>{
        let url = getPath(api: .deleteConversation, conversationID: conversationID)
        
        let request: AnyPublisher<DeleteConversationResponse, Error> = DeleteRequest(pathVariable: nil, params: nil, url: url)
            
        return request
            .map{ _ in
                
            }
            .eraseToAnyPublisher()
    }
}

extension MainConversationRepository {
    
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
