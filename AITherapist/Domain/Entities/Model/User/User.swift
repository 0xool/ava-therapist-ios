//
//  User.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import Foundation
import RealmSwift

class User: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var token: String
    
    override init() {
        super.init()
    }
    
    init(id: Int, token: String) {
        super.init()
        self.id = id
        self.token = token
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(Persisted<Int>.self, forKey: .id)
        self._token = try container.decode(Persisted<String>.self, forKey: .token)
    }
//    var questions: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case token
    }
}

class UserToBeReplaced: Object, Codable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userName: String
    @Persisted var therapistID: Int
    @Persisted var mobile: String
    @Persisted var name: String
    @Persisted var lastName: String
    @Persisted var email: String
    @Persisted var generalSummary: String
    @Persisted var token: String
    
    enum CodingKeys: String, CodingKey {
        case id = "UserID"
        case userName = "Username"
        case therapistID = "TherapistID"
        case mobile = "Mobile"
        case name = "Name"
        case lastName = "LastName"
        case email = "Email"
        case generalSummary = "GeneralSummary"
        case token = "Token"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self , forKey: .id)
        userName = try container.decode(String.self , forKey: .userName)
        therapistID = try container.decode(Int.self , forKey: .therapistID)
        mobile = try container.decode(String.self , forKey: .mobile)
        name = try container.decode(String.self , forKey: .name)
        lastName = try container.decode(String.self , forKey: .lastName)
        email = try container.decode(String.self , forKey: .email)
        generalSummary = try container.decode(String.self , forKey: .generalSummary)
        if let token = try? container.decode(String.self , forKey: .token) {
            self.token = token
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
}
