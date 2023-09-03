//
//  Utilities.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import Foundation
import SwiftUI


struct Constants {
    static let BaseUrl = "http://137.184.10.164:3000"
    static private let sendConversationUrl = "/therapistAnswer"
    static let SendConversationUrl: String = BaseUrl + sendConversationUrl
}

struct ColorPallet{
    static let creameColor: Color = Color(red: 253/255, green: 232/255, blue: 182/255)
    static let greenBackground: Color = Color(red: 222/255, green: 254/255, blue: 202/255)
    static let blueUserMessage: Color = Color(red: 182/255, green: 220/255, blue: 254/255)
    static let greenAiMessage: Color = Color(red: 89/255, green: 139/255, blue: 44/255)
    static let darkColor: Color = Color(red: 33/255, green: 34/255, blue: 39/255)
    static let aiPortraitColor: Color = Color(red: 241/255, green: 171/255, blue: 134/255)
}





