//
//  UserQuote.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

class UserQuote: Object, Codable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var quote: String
    @Persisted var userID: Int
    @Persisted var dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "QuoteID"
        case quote = "Quote"
        case userID = "UserID"
        case dateCreated = "DateCreated"
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self , forKey: .id)
        quote = try container.decode(String.self , forKey: .quote)
        userID = try container.decode(Int.self , forKey: .userID)
        dateCreated = try container.decode(Date.self , forKey: .dateCreated)
    }
    
}
