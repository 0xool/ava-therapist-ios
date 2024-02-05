//
//  Constants.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 10/11/23.
//

import Foundation

struct Constants {
    static let test = false
    static let WebProtocol = test ? "http://" : "https://"
    static let BaseUrl = test ? "localhost" : "aitherapist.online"
    
    static let port = ":3000/"
    static private let sendConversationUrl = "/therapistAnswer"
    static let SendConversationUrl: String = BaseUrl + sendConversationUrl
    
    static let MainUrl = WebProtocol + BaseUrl + port
    static let bgQueue = DispatchQueue(label: "bg_parse_queue")
    static let testQueue = DispatchQueue(label: "test")
}
