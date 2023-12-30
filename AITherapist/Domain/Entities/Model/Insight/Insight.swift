//
//  Insight.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/24/23.
//
import Foundation
import RealmSwift

typealias ConversationSummaries = List<ConversationSummary>
typealias DailyMoods = List<Mood>

class Insight: Object, Codable {
    @Persisted(primaryKey: true) var id: Int = 1
    @Persisted var conversationSummaries: ConversationSummaries
    @Persisted var dailyMoods: DailyMoods
    @Persisted var generalSummary: String?
    @Persisted var quote: String?

    enum CodingKeys: String, CodingKey {
        case conversationSummaries = "conversation_summaries"
        case generalSummary = "general_summary"
        case dailyMoods = "daily_user_moods"
        case quote = "quote"
    }
    
    func getDailyMoodsArray() -> [Mood] {
        Array(self.dailyMoods)
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let generalSummary = try container.decode(String?.self, forKey: CodingKeys.generalSummary)
        let quote = try container.decode(String?.self, forKey: CodingKeys.quote)
        let conversationSummaries = try container.decode(ConversationSummaries.self, forKey: CodingKeys.conversationSummaries)
        let dailyMoods = try container.decode(DailyMoods.self, forKey: CodingKeys.dailyMoods)

        self.init(conversationSummaries: conversationSummaries, dailyMoods: dailyMoods, generalSummary: generalSummary, quote: quote)
    }
    
    convenience init(conversationSummaries: ConversationSummaries, dailyMoods: DailyMoods, generalSummary: String?, quote: String?) {
        self.init()
        self.conversationSummaries = conversationSummaries
        self.dailyMoods = dailyMoods
        self.generalSummary = generalSummary
        self.quote = quote
    }
    
    convenience init(conversationSummaries: ConversationSummaries, dailyMoods: [Mood], generalSummary: String?, quote: String?) {
        self.init()
        self.conversationSummaries = conversationSummaries
        let dailyMoodsList = List<Mood>()
        dailyMoods.forEach { dailyMoodsList.append($0) }
        
        self.dailyMoods = dailyMoodsList
        self.generalSummary = generalSummary
        self.quote = quote
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(conversationSummaries, forKey: CodingKeys.conversationSummaries)
        try container.encode(dailyMoods, forKey: CodingKeys.dailyMoods)
        try container.encode(generalSummary, forKey: CodingKeys.generalSummary)
        try container.encode(quote, forKey: CodingKeys.quote)
    }
        
}
