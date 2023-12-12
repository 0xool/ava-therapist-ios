//
//  ChatRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 10/12/23.
//

import Foundation
import Combine

protocol ChatWebRepository: WebRepository {
    func loadChatsForConversation(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    func sendChatToServer(data: SaveChatRequset) -> AnyPublisher<Chat, Error>
}

struct MainChatWebRepository: ChatWebRepository {
    var AFSession: Session
    
    var session: URLSession
    var bgQueue: DispatchQueue = Constants.bgQueue
    var baseURL: String
    
    let chatAPI = "chat"

    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func sendChatToServer(data: SaveChatRequset) -> AnyPublisher<Chat, Error> {
        
        let url = getPath(api: .addChat)
        do {
            let parameters = try JSONEncoder().encode(data)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddChatServerResponse, Error> = webRequest(url: url, method: .post, parameters: params)
            
            return request
                .map{
                    Chat(message: $0.data.message!, conversationID: $0.data.conversationID!, chatSequence: nil, isUserMessage: false, isSentToserver: .NoStatus)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func loadChatsForConversation(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        
        let url = getPath(api: .getConversationChats, chatID: conversationID)
        let request: AnyPublisher<GetConversationChatServerResponse, Error> = webRequest(url: url, method: .get, parameters: nil)
        
        return request
            .map{
                return $0.data.lazyList
            }
            .eraseToAnyPublisher()
    }
}

extension MainChatWebRepository {
    
    enum API: String {
        case getConversationChats = "getConversationChat"
        case addChat = "addUserChat"
    }
    
    func getPath(api: API, chatID: Int? = nil) -> String {
        let mainUrl = "\(baseURL)\(chatAPI)/\(api.rawValue)"
        switch api {
        case .getConversationChats:
            guard let id = chatID else{
                return mainUrl
            }
            
            return "\(mainUrl)/\(id)"
        case .addChat:
            return mainUrl
        }
    }
}

