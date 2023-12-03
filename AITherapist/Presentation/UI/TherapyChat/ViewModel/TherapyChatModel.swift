//
//  TherapyChatModel.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import Foundation
import Combine
import SwiftUI
//
//class TherapyChatModel: ObservableObject {
//
//    
//    @Published var conversation: Conversation
//    @Published var isUserTurnToSpeak: Bool = true
//    var speechRecognizer = SpeechManager()
//    
//    var didChange = PassthroughSubject<Void, Never>()
//    private let initialAiMessage = "Hi this is Ava your personal therapist. How do you feel today?"
//        
//    func sendMessage(_ chatMessage: String){
//        let message = Message(content: chatMessage, isUser: true)
////        conversation.messages.append(message)
//        didChange.send(())
//        isUserTurnToSpeak = false
//        sendConversation()
//    }
//    
//    func sendConversation() {
//        var conversationList: [String] = []
////        for message in conversation.messages {
//            conversationList.append(message.content)
//        }
//        
//        _ = ["conversation": conversationList]
////        NetworkManager.SendRequest(decoderModel: AiMessageResponse.self, params: params, successHandler: { res in
////
////            guard let value = res.value else { return }
////            let messageResponse: AiMessageResponse = value
////            self.setAiMessage(messageResponse.message)
////            self.isUserTurnToSpeak = true
////
////        }, failedHandler: { res in
////            print(Constants.SendConversationUrl)
////            print(res.error ?? "")
////        }, url: Constants.SendConversationUrl)
//    }
//    
//    func setAiMessage(_ msg: String){
//        let message = Message(content: msg, isUser: false)
////        conversation.messages.append(message)
//        speechRecognizer.readOut(text: message.content)
//    }
//    
//    public func getConversation() -> [Message] {
////        return conversation.messages.map { $0 }
//        return []
//    }
//    
//    public func restart() {
//        self.conversation = Conversation()
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        isUserTurnToSpeak = true
//    }
//    
//    init() {
//        self.conversation = Conversation()
//        setAiMessage(initialAiMessage)
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
////        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//    }
//
//    
//}
