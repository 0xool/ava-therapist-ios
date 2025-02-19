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
    static let mockedJournals: [Diary] = [
        Diary(id: 1, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, userID: 1, summary: "This is a mock summary", dateCreated: .now),
        Diary(id: 2, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, userID: 1, summary: "This is a mock summary", dateCreated: .now - 1),
        Diary(id: 3, diaryMessage: "This is a mock diary", diaryName: "Mock Diary", moodID: 1, userID: 1, summary: "This is a mock summary", dateCreated: .now - 2),
    ]
}

extension Journal {
    static let mockedJournals: [Journal] = [
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

extension Insight {
    static let mockedInsight: Insight = Insight(conversationSummaries: ConversationSummaries(), dailyMoods: [Mood(mood: .Angry, dateCreated: .now, moodString: "Angry")], generalSummary: "test", quote: "test")
}

extension Chat{
    static let mockedChat: Chat = Chat(message: "test", conversationID: 1, chatSequence: 1, isUserMessage: true, isSentToserver: .NoStatus)
    
    static let mockedChatList: [Chat] = [ Chat(id: 1, message: "test", conversationID: 1, chatSequence: 1, isUserMessage: true, isSentToserver: .NoStatus),
                                                  Chat(id: 2, message: "test", conversationID: 1, chatSequence: 2, isUserMessage: false, isSentToserver: .NoStatus),
                                                  Chat(id: 3, message: "test", conversationID: 1, chatSequence: 3, isUserMessage: true, isSentToserver: .NoStatus),
                                                  Chat(id: 4, message: "test", conversationID: 1, chatSequence: 4, isUserMessage: false, isSentToserver: .NoStatus),
                                                  Chat(id: 5, message: "test", conversationID: 1, chatSequence: 5, isUserMessage: true, isSentToserver: .NoStatus),
                                                  Chat(id: 6, message: "test", conversationID: 1, chatSequence: 6, isUserMessage: false, isSentToserver: .NoStatus),
                                                  Chat(id: 7, message: "test", conversationID: 1, chatSequence: 7, isUserMessage: true, isSentToserver: .NoStatus),
                                                  Chat(id: 8, message: "test", conversationID: 1, chatSequence: 8, isUserMessage: false, isSentToserver: .NoStatus),
                                                  Chat(id: 9, message: "test", conversationID: 1, chatSequence: 9, isUserMessage: true, isSentToserver: .NoStatus),
                                                  Chat(id: 10, message: "test", conversationID: 1, chatSequence: 10, isUserMessage: false, isSentToserver: .NoStatus)
    ]
}

extension User {
    static let mockedUser: User = User(id: 1, userName: "cyrus", therapistID: nil, mobile: "310", name: "John", lastname: "Doe", email: "johndoe32@gmail.com", generalSummary: nil, token: "123")
}

#endif

