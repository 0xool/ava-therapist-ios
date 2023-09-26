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
    @Persisted var quote: Quote
    @Persisted var dateCreated: Date
    
    @Persisted var conversationSummaries: ConversationSummaries
    @Persisted var dailyMoods: DailyMoods

    enum CodingKeys: String, CodingKey {
        case id = "insightID"
        case quote = "quote"
        case dateCreated = "dateCreated"
        case conversationSummaries = "conversationSummaries"
        case dailyMoods = "dailyUserMoods"
    }

    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: CodingKeys.id)
        self.quote = try container.decode(Quote.self, forKey: CodingKeys.quote)
        self.dateCreated = try container.decode(Date.self, forKey: CodingKeys.dateCreated)
        self.conversationSummaries = try container.decode(ConversationSummaries.self, forKey: CodingKeys.conversationSummaries)
        self.dailyMoods = try container.decode(DailyMoods.self, forKey: CodingKeys.dailyMoods)
    }
        
}
