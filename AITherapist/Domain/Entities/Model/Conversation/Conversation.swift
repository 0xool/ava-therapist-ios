//
//  Conversation.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import Foundation
import RealmSwift


//struct Conversation:  Identifiable {
//    typealias Identifier = String
//
//    let conversationId: Identifier
//    let summary: String?
//    let moodID: Int?
//    let topDescribingWords: String?
//    let conversationID: Int?
//}

class Conversations: Decodable{
    var conversations: [Conversation]
    
    enum CodingKeys: String, CodingKey {
        case conversations = "Conversations"
    }
    
    init(conversations: [Conversation]) {
        self.conversations = conversations
    }
}

//class Conversation: Object, Decodable  {
//
//    @Persisted(primaryKey: true) var id: Int
//    var conversations: [Message] = []
//
//    enum CodingKeys: String, CodingKey {
//        case conversations
//    }
//
//}

//struct Conversation: Codable {
//    let conversationID: Int
//    let conversationName: String
//    let dateCreated: Date // Assuming you want to decode the date as a Date object
//
//    enum CodingKeys: String, CodingKey {
//        case conversationID = "conversationID"
//        case conversationName = "conversationName"
//        case dateCreated = "dateCreated"
//    }
//}

struct ConversationsResponse: Decodable {
    var code: Int
    var message: String
    var conversations: [Conversation]
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
        case conversations = "conversations"
    }
}

class Conversation: Object, Decodable {
    
    @Persisted(primaryKey: true) var id: Int
//    @Persisted var userID: Int
//    @Persisted var therapistID: Int
//    @Persisted var conversationSummaryID: Int
    @Persisted var conversationName: String
    @Persisted var dateCreated: Date
//    @Persisted var messages: List<Message>
    
//    enum CodingKeys: String, CodingKey {
//        case id = "conversationID"
//        case userID = "UserID"
//        case therapistID = "TherapistID"
//        case conversationSummaryID = "ConversationSummaryID"
//        case conversationName = "conversationName"
//        case dateCreated = "dateCreated"
//    }
    
    enum CodingKeys: String, CodingKey {
        case id = "conversationID"
        case conversationName = "conversationName"
        case dateCreated = "dateCreated"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self , forKey: .id)
//        userID = try container.decode(Int.self , forKey: .userID)
//        therapistID = try container.decode(Int.self , forKey: .therapistID)
//        conversationSummaryID = try container.decode(Int.self , forKey: .conversationSummaryID)
        conversationName = try container.decode(String.self , forKey: .conversationName)
        let date = try container.decode(String.self , forKey: .dateCreated)
        dateCreated = convertStringToDate(date)!
    }
    
    
    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // Assuming the input string is in UTC
        
        return dateFormatter.date(from: dateString)
    }
    
    
}

//class Conversation: Object, Decodable {
//
//    @Persisted(primaryKey: true) var id: Int
//    @Persisted var userID: Int
//    @Persisted var therapistID: Int
//    @Persisted var conversationSummaryID: Int
//    @Persisted var conversationName: String
//    @Persisted var dateCreated: Date
//    @Persisted var messages: List<Message>
//
//    enum CodingKeys: String, CodingKey {
//        case id = "ConversationID"
//        case userID = "UserID"
//        case therapistID = "TherapistID"
//        case conversationSummaryID = "ConversationSummaryID"
//        case conversationName = "ConversationName"
//        case dateCreated = "DateCreated"
//        case messages = "Messages"
//    }
//
//    override init() {
//        super.init()
//    }
//
//    required init(from decoder: Decoder) throws {
//        super.init()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self , forKey: .id)
//        userID = try container.decode(Int.self , forKey: .userID)
//        therapistID = try container.decode(Int.self , forKey: .therapistID)
//        conversationSummaryID = try container.decode(Int.self , forKey: .conversationSummaryID)
//        conversationName = try container.decode(String.self , forKey: .conversationName)
//        dateCreated = try container.decode(Date.self , forKey: .dateCreated)
//    }
//
//}
