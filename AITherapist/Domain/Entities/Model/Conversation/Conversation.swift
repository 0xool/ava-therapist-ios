//
//  Conversation.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import Foundation
import RealmSwift

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

struct AddConversationResponse: Decodable, ServerResponseData{
    var message: String?
    var code: Int?
    var conversationID: Int
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
        case conversationID = "conversationID"
    }
}

struct DeleteConversationResponse: Decodable, ServerResponseData{
    var message: String?
    var code: Int?
}

struct AddConversationRequest: Encodable{
    
    struct AddConversationRequestContainer: Encodable {
        var conversationName: String
    }
    
    var conversation: AddConversationRequestContainer
}

class Conversation: Object, Decodable {
    
    @Persisted(primaryKey: true) var id: Int
    //    @Persisted var userID: Int
    //    @Persisted var therapistID: Int
    //    @Persisted var conversationSummaryID: Int
    @Persisted var conversationName: String
    @Persisted var dateCreated: Date
    @Persisted var chats: List<Chat>
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
    
    init(id: Int, conversationName: String, date: Date){
        super.init()
        self.id = id
        self.conversationName = conversationName
        self.dateCreated = date
        self.chats = List<Chat>()
        
        #warning("Remove test")
        // Tests Remove
//        let chat = Chat(id: 0, message: "Hi, How can I help you?", conversationID: 1, chatSequence: 0, isUserMessage: false)
//        let chat1 = Chat(id: 1, message: "I'm good how are you?", conversationID: 1, chatSequence: 1, isUserMessage: true)
//        let chat2 = Chat(id: 2, message: "Glad to hear that", conversationID: 1, chatSequence: 2, isUserMessage: false)
//        self.chats.append(chat)
//        self.chats.append(chat1)
//        self.chats.append(chat2)
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
