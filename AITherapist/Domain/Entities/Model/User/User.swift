//
//  User.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import Foundation
import RealmSwift

struct UserServerResponse: ServerResponse {
    var data: User
    var message: String?
    var code: Int?
}

class User: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userName: String
    @Persisted var therapistID: Int?
    
    @Persisted var mobile: String
    @Persisted var name: String?
    @Persisted var lastname: String?
    
    @Persisted var email: String
    @Persisted var generalSummary: String?
    @Persisted var token: String
        
    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case userName = "username"
        case therapistID = "therapistID"
        case mobile = "mobile"
        case name = "name"
        case lastname = "lastname"
        case email = "email"
        case generalSummary = "generalSummary"
        case token = "token"
    }
    
    override init() {
        super.init()
    }

    convenience init(id: Int, userName: String, therapistID: Int?, mobile: String, name: String?, lastname: String?, email: String, generalSummary: String?, token: String) {
        self.init()
        self.id = id
        
        self.userName = userName
        self.therapistID = therapistID
        self.mobile = mobile
        
        self.name = name
        self.lastname = lastname
        self.email = email
        
        self.generalSummary = generalSummary
        self.token = token
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self , forKey: .id)
        userName = try container.decode(String.self , forKey: .userName)
        therapistID = try container.decode(Int?.self , forKey: .therapistID)
        
        mobile = try container.decode(String.self , forKey: .mobile)
        name = try container.decode(String?.self , forKey: .name)
        lastname = try container.decodeIfPresent(String.self , forKey: .lastname)
        email = try container.decode(String.self , forKey: .email)
        generalSummary = try container.decodeIfPresent(String.self , forKey: .generalSummary)
        if let token = try? container.decode(String.self , forKey: .token) {
            self.token = token
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
}

struct EditUserInfoRequest: Encodable{
    var user: EditUserData
    
    struct EditUserData: Encodable {
        var username: String
        var name: String
        var lastname: String
    }
}

struct EditUserInfoResponse: ServerResponse {
    var message: String?
    var code: Int?
    var data: String?
}
