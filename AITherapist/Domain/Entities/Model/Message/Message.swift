//
//  Message.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import Foundation
import RealmSwift

class Message: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var content: String
    @Persisted var isUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "ChatID"
        case content = "Content"
        case isUser = "IsUser"
    }
    
    override init() {
        super.init()
    }
    
    init(id: Int = 0, content: String, isUser: Bool) {
        super.init()
        
        self.id = id
        self.content = content
        self.isUser = isUser
    }
}

struct AiMessageResponse: Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
    }

    

}
