//
//  MessageView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import SwiftUI

struct MessageView : View {
    var chat: Chat
    var onResendMessageClicked: (_ chat: Chat) -> ()
    
    var body: some View {
        HStack(alignment: chat.isUserMessage ? .center : .top, spacing: 15) {
                if chat.isSentToServer == .ErrorWhileSending {
                    errorSendingMessageView
                }

            ContentMessageView(contentMessage: chat.message,
                               isUser: chat.isUserMessage)
        }
        .frame(maxWidth: .infinity, alignment: chat.isUserMessage ? .trailing : .leading )
        .padding([.leading, .trailing], 2)
    }
    
    @ViewBuilder var errorSendingMessageView: some View {
        Button {
            onResendMessageClicked(self.chat)
        } label: {
            Image(systemName: "arrow.clockwise.circle.fill")
                .font(.system(size: 30))
                .cornerRadius(10)
                .foregroundColor(.red)
        }
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        let chat = Chat(message: "Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist", conversationID: 10, chatSequence: 1, isUserMessage: false, isSentToserver: .ErrorWhileSending)
        MessageView(chat: chat) { _ in
            print("Resend")
        }
    }
}
