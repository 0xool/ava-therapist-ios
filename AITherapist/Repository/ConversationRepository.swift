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
                print($0)
                return $0.conversations
            }
            .eraseToAnyPublisher()
    }
}

extension MainConversationRepository {
    
    enum API: String {
        case allConversations = "getConversationList"
        case addConversation = "addConversation"
    }
    
    func getPath(api: API) -> String {
        switch api {
        case .addConversation:
            return "\(baseURL)\(ConversationAPI)/\(api.rawValue)"
        case .allConversations:
            return "\(baseURL)\(ConversationAPI)/\(api.rawValue)"
        }
    }
}
