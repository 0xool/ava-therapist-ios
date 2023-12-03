//
//  Journal.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Foundation
import RealmSwift

struct DiaryBook: Decodable {
    let journals: [Journal]
}

class Journal: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var diaryMessage: String
    @Persisted var diaryName: String
    
    @Persisted var moodID: Int?
    @Persisted var summary: String?
    @Persisted var _dateCreated: Date
    @Persisted var dateCreatedString: String
    
    var dateCreated: Date{
        get{
            return _dateCreated
        }set{
            dateCreatedString = newValue.description.prefix(10).description
            _dateCreated = newValue
        }
    }
    // Return _tags as [JournalTagType]
    var tags: [JournalTagType] {
        get {
            return Array(_tags)
        }
        set {
            _tags.removeAll()
            _tags.append(objectsIn: newValue)            
        }
    }
    
    @Persisted var _tags: List<JournalTagType>
    
    enum CodingKeys: String, CodingKey {
        case id = "diaryID"
        case diaryMessage = "diaryMessage"
        case diaryName = "diaryName"
        
        case moodID = "moodID"
        case summary = "summary"
        case dateCreated = "dateCreated"
    }
    
    init(id: Int, diaryMessage: String, diaryName: String, moodID: Int?, summary: String?, dateCreated: Date, tags: [JournalTagType]) {
        super.init()
        self.id = id
        self.diaryMessage = diaryMessage
        
        self.diaryName = diaryName
        self.moodID = moodID
        self.summary = summary
        
        self.dateCreated = dateCreated
        self.tags = tags
        self.dateCreatedString = self.dateCreated.description.prefix(10).description
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.diaryMessage = try container.decode(String.self, forKey: .diaryMessage)
        
        self.diaryName = try container.decode(String.self, forKey: .diaryName)
        self.moodID = try container.decode(Int?.self, forKey: .moodID)
        self.summary = try container.decode(String?.self, forKey: .summary)
        
        self.dateCreated = Date.convertStringToDate(try container.decode(String.self, forKey: .dateCreated))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        
        try container.encode(self.diaryMessage, forKey: .diaryMessage)
        try container.encode(self.diaryName, forKey: .diaryName)
        
        try container.encode(self.moodID, forKey: .moodID)
        try container.encode(self.summary, forKey: .summary)
        
        try container.encode(self.dateCreated.description, forKey: .dateCreated)
    }
}

enum JournalTagType: String, PersistableEnum {
    case Personal = "Personal"
    case Happy = "Happy"
    case Sad = "Sad"
    case Family = "Family"
    
    var tag: String {
        switch self {
        case .Personal:
            return "Personal"
        case .Happy:
            return "Happy"
        case .Sad:
            return "Sad"
        case .Family:
            return "Family"
        }
    }
    
    static var allTypes: [JournalTagType] {
        return [.Personal, .Happy, .Sad, .Family]
    }
    
    var tagId: Int {
        switch self {
        case .Personal:
            return 1
        case .Happy:
            return 2
        case .Sad:
            return 3
        case .Family:
            return 4
        }
    }
    
    var tagColor: String {
        switch self {
        case .Personal:
            return "#FFC107"
        case .Happy:
            return "#4CAF50"
        case .Sad:
            return "#F44336"
        case .Family:
            return "#2196F3"
        }
    }
}

struct AddJournalRequest: Encodable{
    var diary: Journal
}

struct GetJournalByDateRequest: Encodable{
    var date: String
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
    var code: Int?
    var message: String?
    var data: [Journal]
}

struct GetJournalByDateResponse: Decodable, ServerResponseData {
    var code: Int?
    var message: String?
    var data: Journal
}
