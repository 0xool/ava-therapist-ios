//
//  Journal.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Foundation
import RealmSwift

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
            _dateCreated
        }set{
            dateCreatedString = newValue.description.prefix(10).description
            _dateCreated = newValue
        }
    }
    // Return _tags as [JournalTagType]
    var tags: [JournalTagType] {
        get {
            Array(_tags)
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

extension Journal {
    static func == (lhs: Journal, rhs: Journal) -> Bool {
        lhs.id == rhs.id
    }
    
    static func != (lhs: Journal, rhs: Journal) -> Bool {
        lhs.id != rhs.id
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
            "Personal"
        case .Happy:
            "Happy"
        case .Sad:
            "Sad"
        case .Family:
            "Family"
        }
    }
    
    static var allTypes: [JournalTagType] {
        [.Personal, .Happy, .Sad, .Family]
    }
    
    var tagId: Int {
        switch self {
        case .Personal:
            1
        case .Happy:
            2
        case .Sad:
            3
        case .Family:
            4
        }
    }
    
    var tagColor: String {
        switch self {
        case .Personal:
            "#FFC107"
        case .Happy:
            "#4CAF50"
        case .Sad:
            "#F44336"
        case .Family:
            "#2196F3"
        }
    }
}

struct AddJournalRequest: Encodable{
    var diary: Journal
}

struct GetJournalByDateRequest: Encodable{
    var date: String
}

struct AddJournalResponse: ServerResponse {
    var message: String?
    var code: Int?
    var data: String
}

struct DeleteJournalResponse: ServerResponse{
    var message: String?
    var code: Int?
    var data: String
}

struct GetAllJournalResponse: ServerResponse {
    var code: Int?
    var message: String?
    var data: [Journal]
}

struct GetJournalByDateResponse: ServerResponse {
    var code: Int?
    var message: String?
    var data: Journal?
}

extension Journal {
    static let journals: [Journal] = [
        Journal(id: 1, diaryMessage: "I had a great day today", diaryName: "My Day", moodID: 1, summary: "I had a great day today", dateCreated: Date(), tags: [.Personal, .Happy]),
        Journal(id: 2, diaryMessage: "I had a bad day today", diaryName: "My Day", moodID: 3, summary: "I had a bad day today", dateCreated: Date(), tags: [.Personal, .Sad]),
        Journal(id: 3, diaryMessage: "I had a great day today", diaryName: "My Day", moodID: 1, summary: "I had a great day today", dateCreated: Date(), tags: [.Personal, .Happy]),
        Journal(id: 4, diaryMessage: "I had a bad day today", diaryName: "My Day", moodID: 3, summary: "I had a bad day today", dateCreated: Date(), tags: [.Personal, .Sad]),
        Journal(id: 5, diaryMessage: "I had a great day today", diaryName: "My Day", moodID: 1, summary: "I had a great day today", dateCreated: Date(), tags: [.Personal, .Happy]),
        Journal(id: 6, diaryMessage: "I had a bad day today", diaryName: "My Day", moodID: 3, summary: "I had a bad day today", dateCreated: Date(), tags: [.Personal, .Sad]),
        Journal(id: 7, diaryMessage: "I had a great day today", diaryName: "My Day", moodID: 1, summary: "I had a great day today", dateCreated: Date(), tags: [.Personal, .Happy]),
        Journal(id: 8, diaryMessage: "I had a bad day today", diaryName: "My Day", moodID: 3, summary: "I had a bad day today", dateCreated: Date(), tags: [.Personal, .Sad]),
        Journal(id: 9, diaryMessage: "I had a great day today", diaryName: "My Day", moodID: 1, summary: "I had a great day today", dateCreated: Date(), tags: [.Personal, .Happy]),
    ]
}
