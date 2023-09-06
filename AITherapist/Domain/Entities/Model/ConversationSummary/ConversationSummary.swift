//
//  ConversationSummary.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/2/23.
//

import Foundation
   
struct ConversationSummary:  Identifiable {
    var id: String { conversationSummaryId }
    
    typealias Identifier = String

    let conversationSummaryId: Identifier
    let summary: String?
    let MoodID: Int?
    let TopDescribingWords: String?
    let ConversationID: Int?
}
