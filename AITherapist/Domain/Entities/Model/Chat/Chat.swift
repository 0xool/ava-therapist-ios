//
//  Chat.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/2/23.
//

import Foundation
import RealmSwift

struct GetConversationChatServerResponse: ServerResponse {
    var code: Int?
    var message: String?
    var data: [Chat]
    
    enum CodingKeys: CodingKey {
        case code
        case message
        case data
    }
}

struct AddChatServerResponse: ServerResponse {    
    var message: String?
    var code: Int?
    var data: AddChatServerResponseData
    
    struct AddChatServerResponseData: Decodable {
        var botChat: Chat
        var userChat: Chat
    }
}

struct SaveChatRequset: Encodable, Equatable{
    static func == (lhs: SaveChatRequset, rhs: SaveChatRequset) -> Bool {
        lhs.chat.message == rhs.chat.message && lhs.chat.conversationID == rhs.chat.conversationID
    }
    
    var chat: SaveChatRequsetBody
}

struct SaveChatRequsetBody: Encodable {
    var message: String
    var conversationID: Int
}

enum ChatState: String, PersistableEnum {
    case BeingSent
    case ErrorWhileSending
    case NoStatus
    case LoadingServerChat
    case LastServerChat
}



class Chat: Object, Codable, Identifiable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var message: String
    @Persisted var conversationID: Int
    
    @Persisted var chatSequence: Int?
    @Persisted var isUserMessage: Bool
    @Persisted var chatState: ChatState = .NoStatus
//    @Persisted var dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "chatID"
        case message = "message"
        case conversationID = "conversationID"
        case chatSequence = "chatSequence"
        case isUserMessage = "isUserMessage"
//        case dateCreated = "DateCreated"
    }
    
    init(message: String, conversationID: Int, chatSequence: Int?, isUserMessage: Bool, isSentToserver: ChatState = .NoStatus){
        super.init()
        self.id = DataBaseManager.Instance.IncrementaChatID()
        self.message = message
        self.conversationID = conversationID
        
        self.chatSequence = chatSequence
        self.isUserMessage = isUserMessage
        self.chatState = isSentToserver
//        self.dateCreated = dateCreated
    }
    
    init(id: Int, message: String, conversationID: Int, chatSequence: Int?, isUserMessage: Bool, isSentToserver: ChatState = .NoStatus){
        super.init()
        self.id = id
        self.message = message
        self.conversationID = conversationID
        
        self.chatSequence = chatSequence
        self.isUserMessage = isUserMessage
        self.chatState = isSentToserver
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self , forKey: .id)
        
        self.message = try container.decode(String.self , forKey: .message)
        self.conversationID = try container.decode(Int.self , forKey: .conversationID)
        self.chatSequence = try container.decode(Int?.self , forKey: .chatSequence)
        self.isUserMessage = try container.decode(Bool.self , forKey: .isUserMessage)
        self.chatState = .NoStatus
//        dateCreated = try container.decode(Date.self , forKey: .dateCreated)
    }
    
}
