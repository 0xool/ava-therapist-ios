//
//  ConversationSummary.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import Foundation
import RealmSwift

class ConversationSummary: Object, Decodable {

    @Persisted(primaryKey: true) var id: Int
    @Persisted var summary: String?
    @Persisted var mood: Mood?
    @Persisted var topDescribingWords: String?
    @Persisted var conversationID: Int?
    @Persisted var dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "conversationSummaryID"
        case summary = "summary"
        case mood = "mood"
        case topDescribingWords = "topDescribingWords"
        case conversationID = "conversationID"
        case dateCreated = "dateCreated"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, summary: String?, mood: Mood?, topDescribingWords: String?, conversationID: Int?, dateCreated: Date) {
        self.init()
        self.id = id
        self.summary = summary
        self.mood = mood
        self.topDescribingWords = topDescribingWords
        self.conversationID = conversationID
        self.dateCreated = dateCreated
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: CodingKeys.id)
        let summary = try container.decode(String?.self, forKey: CodingKeys.summary)
        let mood = try container.decode(Mood.self, forKey: CodingKeys.mood)
        let topDescribingWords = try container.decode(String?.self, forKey: CodingKeys.topDescribingWords)
        let conversationID = try container.decode(Int?.self, forKey: CodingKeys.conversationID)
        let dateCreated = try container.decode(Date.self, forKey: CodingKeys.dateCreated)
        self.init(id: id, summary: summary, mood: mood, topDescribingWords: topDescribingWords, conversationID: conversationID, dateCreated: dateCreated)
    }
}

class ConversationSummaries: EmbeddedObject, Decodable {
    @Persisted var conversationSummaries: List<ConversationSummary>
    
    enum CodingKeys: String, CodingKey {
        case conversationSummaries = "conversationSummaries"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let conversationSummaries = try container.decode(List<ConversationSummary>.self, forKey: .conversationSummaries)
        self.init(conversationSummaries: conversationSummaries)
    }

    convenience init(conversationSummaries: List<ConversationSummary>) {
        self.init()
        self.conversationSummaries = conversationSummaries
    }
}
