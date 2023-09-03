//
//  User.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import Foundation

class User: Identifiable, Decodable {
    var id: Int = 0
    var userName: String = ""
    var userFeeling: UserFeeling?
    
//    var questions: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName
//        case userFeeling
    }
    
}
