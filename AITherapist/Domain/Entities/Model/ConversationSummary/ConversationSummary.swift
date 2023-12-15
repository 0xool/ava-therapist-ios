//
//  ConversationSummary.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/2/23.
//

import Foundation
import RealmSwift

class ConversationSummary: Object, Codable {

    @Persisted(primaryKey: true) var id: Int
    @Persisted var summary: String?
    @Persisted var mood: Mood?
    @Persisted var topDescribingWords: String?
    @Persisted var conversationID: Int?
    @Persisted var dateCreated: String?
    @Persisted var conversationName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ConversationSummaryID"
        case summary = "Summary"
        case mood = "MoodID"
        case topDescribingWords = "TopDescribingWords"
        case conversationID = "ConversationID"
        case dateCreated = "DateCreated"
        case conversationName = "ConversationName"
    }
    
    convenience init(id: Int, summary: String?, mood: Mood?, topDescribingWords: String?, conversationID: Int?, dateCreated: String?, conversationName: String?) {
        self.init()
        self.id = id
        self.summary = summary
        self.mood = mood
        self.topDescribingWords = topDescribingWords
        self.conversationID = conversationID
        self.dateCreated = dateCreated
        self.conversationName = conversationName
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: CodingKeys.id)
        let summary = try container.decode(String?.self, forKey: CodingKeys.summary)
        let mood = try? container.decode(Mood.self, forKey: CodingKeys.mood)
        let topDescribingWords = try container.decode(String?.self, forKey: CodingKeys.topDescribingWords)
        let conversationID = try container.decode(Int?.self, forKey: CodingKeys.conversationID)
        let conversationName = try container.decode(String?.self, forKey: CodingKeys.conversationName)
        let dateCreated = try container.decode(String.self, forKey: CodingKeys.dateCreated)
        self.init(id: id, summary: summary, mood: mood, topDescribingWords: topDescribingWords, conversationID: conversationID, dateCreated: dateCreated, conversationName: conversationName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(summary, forKey: CodingKeys.summary)
        try container.encode(mood, forKey: CodingKeys.mood)
        try container.encode(topDescribingWords, forKey: CodingKeys.topDescribingWords)
        try container.encode(conversationID, forKey: CodingKeys.conversationID)
        try container.encode(dateCreated, forKey: CodingKeys.dateCreated)
        try container.encode(conversationName, forKey: CodingKeys.conversationName)
    }
}

//class ConversationSummaries: EmbeddedObject, Decodable {
//    @Persisted var conversationSummaries: List<ConversationSummary>
//    
//    enum CodingKeys: String, CodingKey {
//        case conversationSummaries = "conversation_summaries"
//    }
//    
//    convenience required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let conversationSummaries = try container.decode(List<ConversationSummary>.self, forKey: .conversationSummaries)
//        self.init(conversationSummaries: conversationSummaries)
//    }
//
//    convenience init(conversationSummaries: List<ConversationSummary>) {
//        self.init()
//        self.conversationSummaries = conversationSummaries
//    }
//}
