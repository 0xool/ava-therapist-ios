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
}

struct MainChatRepository: ChatRepository {
    
    var baseURL: String
    let chatAPI = "chat"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadChatsForConversation(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        
        let url = getPath(api: .getConversationChats) + "/\(conversationID)"
        let request: AnyPublisher<ChatServerResponse, Error> = GetRequest(pathVariable: nil, params: nil, url: url)
        
        return request
            .map{
                print($0)
                return $0.chats.lazyList
            }
            .eraseToAnyPublisher()
    }
}

extension MainChatRepository {
    
    enum API: String {
        case getConversationChats = "getConversationChat"
        case addChat = "addChat"
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

