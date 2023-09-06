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
        
        let params = ["userId" : "1"]   
        
        let request: AnyPublisher<[Conversation], Error> = GetRequest(pathVariable: nil, params: params, url: getPath(api: .allConversations))
        return request
            .eraseToAnyPublisher()
    }
    
//    func loadConversationChat(conversation: Conversation) -> AnyPublisher<[Message], Error> {
//
//
////        return AnyPublisher
//    }
    
}

extension MainConversationRepository {
    
    enum API: String {
        case allConversations = "getConversationList"
    }
    
    func getPath(api: API) -> String {
        switch api {
        case .allConversations:
            return "\(baseURL)\(ConversationAPI)/\(api.rawValue)"
        }
    }
}
