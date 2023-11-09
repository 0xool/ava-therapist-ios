//
//  Journal.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import Foundation
import RealmSwift

struct DiaryBook: Decodable {
    let journals: [Journal]
}

class Journal: Object, Decodable {
    @Persisted(primaryKey: true) private var id: Int
    @Persisted var diaryMessage: String
    @Persisted var diaryName: String
    @Persisted var moodID: Int
    @Persisted var userID: Int
    @Persisted var summary: String
    @Persisted var dateCreated: Date?

    enum CodingKeys: String, CodingKey {
        case id = "DiaryID"
        case diaryMessage = "DiaryMessage"
        case diaryName = "DiaryName"
        case moodID = "MoodID"
        case userID = "UserID"
        case summary = "Summary"
        case dateCreated = "DateCreated"
    }
    
    init(id: Int, diaryMessage: String, diaryName: String, moodID: Int, userID: Int, summary: String, dateCreated: Date?) {
        super.init()
        self.id = id
        self.diaryMessage = diaryMessage
        self.diaryName = diaryName
        self.moodID = moodID
        self.userID = userID
        self.summary = summary
        self.dateCreated = dateCreated
    } 
    
    override init() {
        
    }

    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)

        self.diaryMessage = try container.decode(String.self, forKey: .diaryMessage)
        self.diaryName = try container.decode(String.self, forKey: .diaryName)
        self.moodID = try container.decode(Int.self, forKey: .moodID)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.dateCreated = Date.convertStringToDate(try container.decode(String.self, forKey: .dateCreated))
    }

}

struct AddJournalRequset: Encodable{
    var diary: SaveJournalRequsetBody
    
    struct SaveJournalRequsetBody: Encodable {
        var diaryName: String
        var diaryMessage: String
    }
}

struct AddJournalResponse: Decodable, ServerResponseData {
    var message: String?
    var code: Int?
}

struct DeleteJournalResponse: Decodable, ServerResponseData{
    var message: String?
    var code: Int?
}

struct GetAllJournalResponse: Decodable, ServerResponseData {

    var message: String?
    var code: Int?
    var data: DiaryBook
    
    struct AddChatServerResponseData: Decodable {
        var message: String?
        var conversationID: Int?
        var transcription: String?
    }
}
