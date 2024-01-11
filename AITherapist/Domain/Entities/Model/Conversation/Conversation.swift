//
//  Conversation.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/2/23.
//

import Foundation
import RealmSwift

class Conversations: Decodable{
//    static func == (lhs: Conversations, rhs: Conversations) -> Bool {
//        lhs.conversations == rhs.conversations
//    }
    
    var conversations: [Conversation]
    
    enum CodingKeys: String, CodingKey {
        case conversations = "Conversations"
    }
    
    init(conversations: [Conversation]) {
        self.conversations = conversations
    }
}

struct ConversationsResponse: ServerResponse {
    var code: Int?
    var message: String?
    var data: [Conversation]
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
        case data = "data"
    }
}

struct AddConversationResponse: Decodable, ServerResponse{
    var message: String?
    var code: Int?
    var data: Conversation
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
        case data = "data"
    }
}

struct DeleteConversationResponse: Decodable, ServerResponse{
    var message: String?
    var code: Int?
    var data: String
}

struct AddConversationRequest: Encodable, Equatable{
    static func == (lhs: AddConversationRequest, rhs: AddConversationRequest) -> Bool {
        lhs.conversation.conversationName == rhs.conversation.conversationName
    }
    
    struct AddConversationRequestContainer: Encodable {
        var conversationName: String
    }
    
    var conversation: AddConversationRequestContainer
}

class Conversation: Object, Codable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var conversationName: String
    @Persisted var dateCreated: Date
    
    @Persisted var chats: List<Chat>
    @Persisted var summary: String?
//    @Persisted var topWords: List<String>
    
    enum CodingKeys: String, CodingKey {
        case id = "conversationID"
        case conversationName = "conversationName"
        case dateCreated = "dateCreated"
        case summary = "conversaionSummary"
    }
    
    override init() {
        super.init()
    }
    
    init(id: Int, conversationName: String, date: Date, summary: String? = nil){
        super.init()
        self.id = id
        self.conversationName = conversationName
        
        self.dateCreated = date
        self.chats = List<Chat>()
//        self.topWords = List<String>()
        
        self.summary = summary
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self , forKey: .id)
        conversationName = try container.decode(String.self , forKey: .conversationName)
        
        dateCreated = convertServerDateStringToDate(serverDate: try container.decode(String.self , forKey: .dateCreated))
        
        summary = try container.decodeIfPresent(String.self , forKey: .summary)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id , forKey: .id)
        try container.encode(conversationName , forKey: .conversationName)
        
        try container.encode(dateCreated , forKey: .dateCreated)
        try container.encode(summary , forKey: .summary)
    }
}
