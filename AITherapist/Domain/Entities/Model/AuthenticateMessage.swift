//
//  AuthenticateMessage.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/11/23.
//

import Foundation

class AuthenticateMessage: Decodable {
    var username: String
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case username
    }
}
