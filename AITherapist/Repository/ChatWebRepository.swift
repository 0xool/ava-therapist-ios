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
                    Chat(message: $0.data.message!, conversationID: $0.data.conversationID!, chatSequence: nil, isUserMessage: false, isSentToserver: .NoStatus)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func loadChatsForConversation(conversationID: Int) -> AnyPublisher<LazyList<Chat>, Error> {
        
        let url = getPath(api: .getConversationChats, chatID: conversationID)
        let request: AnyPublisher<GetConversationChatServerResponse, Error> = GetRequest(pathVariable: nil, params: nil, url: url)
        
        return request
            .map{
                return $0.chats.lazyList
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

