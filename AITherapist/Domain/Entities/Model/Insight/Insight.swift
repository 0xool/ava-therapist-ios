//
//  Insight.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/24/23.
//
import Foundation
import RealmSwift

class Insight: Object, Decodable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var quote: Quote?
    @Persisted var dateCreated: Date
    
    @Persisted var conversationSummaries: ConversationSummaries?
    @Persisted var dailyMoods: DailyMoods?

    enum CodingKeys: String, CodingKey {
        case id = "insightID"
        case quote = "quote"
        case dateCreated = "dateCreated"
        case conversationSummaries = "conversationSummaries"
        case dailyMoods = "dailyUserMoods"
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: CodingKeys.id)
        let quote = try container.decode(Quote.self, forKey: CodingKeys.quote)
        let dateCreated = try container.decode(Date.self, forKey: CodingKeys.dateCreated)
        let conversationSummaries = try container.decode(ConversationSummaries.self, forKey: CodingKeys.conversationSummaries)
        let dailyMoods = try container.decode(DailyMoods.self, forKey: CodingKeys.dailyMoods)
        self.init(id: id, quote: quote, dateCreated: dateCreated, conversationSummaries: conversationSummaries, dailyMoods: dailyMoods)
    }
    
    convenience init(id: Int, quote: Quote, dateCreated: Date, conversationSummaries: ConversationSummaries, dailyMoods: DailyMoods) {
        self.init()
        self.id = id
        self.quote = quote
        self.dateCreated = dateCreated
        self.conversationSummaries = conversationSummaries
        self.dailyMoods = dailyMoods
    }
        
}
