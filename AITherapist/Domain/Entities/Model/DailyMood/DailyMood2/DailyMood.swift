//
//  DailyMood.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import Foundation

struct DailyMood: Codable, Hashable, Identifiable {
    var id: Int {
        DailyMoodID
    }
    
    typealias Identifier = Int

    var DailyMoodID: Identifier
    var MoodID: Int
    var UserID: Int
    var DateCreated: Date
}

extension DailyMood{
    enum CodingKeys: String, CodingKey {
        case DailyMoodID
        case MoodID
        case UserID
        case DateCreated
    }
}

extension DailyMood{
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        DailyMoodID = try container.decode(Identifier.self, forKey: .DailyMoodID)
        MoodID = try container.decode(Int.self, forKey: .MoodID)
        UserID = try container.decode(Int.self, forKey: .UserID)
        DateCreated = try container.decode(Date.self, forKey: .DateCreated)
    }
    
}
