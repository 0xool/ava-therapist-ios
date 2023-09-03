//
//  TherapyChatModel.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import Foundation
import Combine

class TherapyChatModel: ObservableObject {

    
    @Published var conversation: Conversation
    @Published var isUserTurnToSpeak: Bool = true
    var speechRecognizer = SpeechManager()
    
    var didChange = PassthroughSubject<Void, Never>()
    private let initialAiMessage = "Hi this is Ava your personal therapist. How do you feel today?"
        
    func sendMessage(_ chatMessage: String){
        let message = Message(content: chatMessage, isUser: true)
        conversation.conversations.append(message)
        didChange.send(())
        isUserTurnToSpeak = false
        sendConversation()
    }
    
    func sendConversation() {
        
        var conversationList: [String] = []
        for message in conversation.conversations {
            conversationList.append(message.content)
        }
        
        let params = ["conversation": conversationList]
        `NetworkManager.SendRequest(decoderModel: AiMessageResponse.self, params: params, successHandler: { res in
            
            guard let value = res.value else { return }
            let messageResponse: AiMessageResponse = value
            self.setAiMessage(messageResponse.message)
            self.isUserTurnToSpeak = true
            
        }, failedHandler: { res in
            print(Constants.SendConversationUrl)
            print(res.error ?? "")
        }, url: Constants.SendConversationUrl)
    }
    
    func setAiMessage(_ msg: String){
        let message = Message(content: msg, isUser: false)
        conversation.conversations.append(message)
        speechRecognizer.readOut(text: message.content)
    }
    
    public func getConversation() -> [Message] {
        return conversation.conversations
    }
    
    public func restart() {
        self.conversation = Conversation()
        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
        isUserTurnToSpeak = true
    }
    
    init() {
        self.conversation = Conversation()
        setAiMessage(initialAiMessage)
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
//        setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
    }

    
}
