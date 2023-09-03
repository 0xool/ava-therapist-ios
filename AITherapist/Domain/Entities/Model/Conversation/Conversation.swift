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


struct Conversation: Object, Decodable  {
    
    @Persisted(primaryKey: true) var id: Int
    var conversations: [Message] = []
    
    enum CodingKeys: String, CodingKey {
        case conversations
    }
    
}
