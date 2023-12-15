//
//  MockedData.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/13/23.
//

import Foundation

#if DEBUG

extension Diary {
    // Create mock diary
    static let mockedData: [Diary] = [
        Diary(id: 1, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, userID: 1, summary: "This is a mock summary", dateCreated: .now),
        Diary(id: 2, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, userID: 1, summary: "This is a mock summary", dateCreated: .now - 1),
        Diary(id: 3, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, userID: 1, summary: "This is a mock summary", dateCreated: .now - 2),
    ]
}

extension Journal {
    static let mockedData: [Journal] = [
        Journal(id: 1, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, summary: "This is a mock summary", dateCreated: .now, tags: [.Personal, .Sad]),
        Journal(id: 2, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, summary: "This is a mock summary", dateCreated: .now - 1, tags: [.Sad]),
        Journal(id: 3, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, summary: "This is a mock summary", dateCreated: .now - 2, tags: []),
    ]

    static let mockedJournal: Journal = Journal(id: 1, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, summary: "This is a mock summary", dateCreated: .now, tags: [.Personal, .Sad])
}

extension Conversation {
    static let mockedConversation: Conversation = Conversation(id: 1, conversationName: "test", date: .now
    )
    
    static let mockedConversations: [Conversation] = [
        Conversation(id: 1, conversationName: "test", date: .now),
        Conversation(id: 2, conversationName: "test", date: .now - 1),
        Conversation(id: 3, conversationName: "test", date: .now - 2),
    ]
}

//extension Insight {
//    static let mockedInsight: Insight = Insight(conversationSummaries: ConversationSummaries(), dailyMoods: [Mood(mood: .Angry, dateCreated: .now, moodString: "Angry")], generalSummary: "test")
//}

#endif

