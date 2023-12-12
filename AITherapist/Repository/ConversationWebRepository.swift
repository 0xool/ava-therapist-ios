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
    var AFSession: Session = .default
    
    var session: URLSession
    var baseURL: String
    var bgQueue: DispatchQueue = Constants.bgQueue
    
    let ConversationAPI = "conversation"

    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.bgQueue = Constants.bgQueue
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func loadConversationList() -> AnyPublisher<[Conversation], Error> {
        
        let request: AnyPublisher<ConversationsResponse, Error> = 
        webRequest(url: getPath(api: .allConversations), method: .get, parameters: nil, headers: nil)
        
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
            let request: AnyPublisher<AddConversationResponse, Error> = webRequest(url: url, method: .post, parameters: params, headers: nil)
            
            return request
                .map{ $0.data }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func deleteConversation(conversationID: Int) -> AnyPublisher<Void, Error>{
        let url = getPath(api: .deleteConversation, conversationID: conversationID)
        
        let request: AnyPublisher<DeleteConversationResponse, Error> = webRequest(url: url, method: .delete, parameters: nil, headers: nil)
            
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
