//
//  Chat.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import Foundation
import RealmSwift

class Chat: Object, Codable, Identifiable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var message: String
    @Persisted var conversationID: Int
    
    @Persisted var chatSequence: Int
    @Persisted var isUserMessage: Bool
    @Persisted var dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "ChatID"
        case message = "Message"
        case conversationID = "ConversationID"
        case chatSequence = "ChatSequence"
        case isUserMessage = "IsUserMessage"
        case dateCreated = "DateCreated"
    }
    
    init(id: Int, message: String, conversationID: Int, chatSequence: Int, isUserMessage: Bool, dateCreated: Date){
        super.init()
        self.id = id
        self.message = message
        self.conversationID = conversationID
        
        self.chatSequence = chatSequence
        self.isUserMessage = isUserMessage
        self.dateCreated = dateCreated
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self , forKey: .id)
        message = try container.decode(String.self , forKey: .message)
        conversationID = try container.decode(Int.self , forKey: .conversationID)
        chatSequence = try container.decode(Int.self , forKey: .chatSequence)
        isUserMessage = try container.decode(Bool.self , forKey: .isUserMessage)
        dateCreated = try container.decode(Date.self , forKey: .dateCreated)
    }
    
}
