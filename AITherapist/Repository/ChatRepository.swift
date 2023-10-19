//
//  ChatRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 10/12/23.
//

import Foundation
import Combine

protocol ChatRepository: WebRepository {
    func loadChatsForConversation(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error>
    func sendChatToServer(data: SaveChatRequset) -> AnyPublisher<Chat, Error>
}

struct MainChatRepository: ChatRepository {
    
    var baseURL: String
    let chatAPI = "chat"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func sendChatToServer(data: SaveChatRequset) -> AnyPublisher<Chat, Error> {
        
        let url = getPath(api: .addChat)
        do {
            let parameters = try JSONEncoder().encode(data)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddChatServerResponse, Error> = SendRequest(pathVariable: nil, params: params, url: url)
            return request
                .map{
                    Chat(message: $0.chat.message, conversationID: $0.chat.conversationID, chatSequence: $0.chat.chatSequence, isUserMessage: false, isSentToserver: .NoStatus)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func loadChatsForConversation(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        
        let url = getPath(api: .getConversationChats) + "/\(conversationID)"
        let request: AnyPublisher<GetConversationChatServerResponse, Error> = GetRequest(pathVariable: nil, params: nil, url: url)
        
        return request
            .map{
                return $0.chats.lazyList
            }
            .eraseToAnyPublisher()
    }
}

extension MainChatRepository {
    
    enum API: String {
        case getConversationChats = "getConversationChat"
        case addChat = "addUserChat"
    }
    
    func getPath(api: API) -> String {
        switch api {
        case .getConversationChats:
            return "\(baseURL)\(chatAPI)/\(api.rawValue)"
        case .addChat:
            return "\(baseURL)\(chatAPI)/\(api.rawValue)"
        }
    }
}

