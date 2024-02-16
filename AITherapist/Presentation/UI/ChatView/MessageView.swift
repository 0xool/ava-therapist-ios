//
//  MessageView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct MessageView : View {
    var chat: Chat
    var onResendMessageClicked: (_ chat: Chat) -> ()
    private let chatState: ChatState
    
    init(chat: Chat, onResendMessageClicked: @escaping (_: Chat) -> Void, animateChatBubble: Bool = false) {
        self.chat = chat
        self.onResendMessageClicked = onResendMessageClicked
        chatState = chat.chatState
    }
    
    var body: some View {
            HStack(spacing: 10) {
                if self.chatState == .ErrorWhileSending {
                    errorSendingMessageView
                }
                
                ContentMessageView(contentMessage: chat.message,
                                   isUser: chat.isUserMessage, withAnimation: (chat.chatState == .BeingSent)
                                   , animateText: (chat.chatState == .LastServerChat)
                              )
                
                if self.chat.chatState == .LoadingServerChat {
                    LoadingIndicator(animation: .circleBlinks, color: ColorPallet.DarkGreen, size: .small, speed: .fast)
                }
            }
            .frame(maxWidth: .infinity, alignment: chat.isUserMessage ? .trailing : .leading )
            .padding([.leading], chat.isUserMessage ? 32 : 4)
            .padding([.trailing], chat.isUserMessage ? 4 : 32)
    }
    
    @ViewBuilder var errorSendingMessageView: some View {
        Button {
            onResendMessageClicked(self.chat)
        } label: {
            Image(systemName: "arrow.clockwise.circle.fill")
                .font(.system(size: 25))
                .cornerRadius(10)
                .foregroundColor(.red)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        let chat = Chat(id: 1, message: "Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist", conversationID: 10, chatSequence: 1, isUserMessage: false, isSentToserver: .LoadingServerChat)
        MessageView(chat: chat) { _ in
            print("Resend")
        }
    }
}
