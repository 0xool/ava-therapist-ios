//
//  MessageView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import SwiftUI

struct MessageView : View {
    var chat: Chat
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            if !chat.isUserMessage {
                ZStack {
                    Circle()
                        .foregroundColor(ColorPallet.SecondaryColorBlue)
                    .frame(width: 40, height: 40, alignment: .top)
                    Text("Ava")
                        .foregroundColor(.black)
                }
            } else {
                Spacer()
            }
            ContentMessageView(contentMessage: chat.message,
                               isUser: chat.isUserMessage)
        }
        .frame(maxWidth: .infinity, alignment: chat.isUserMessage ? .trailing : .leading )
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        let chat = Chat(id: 0, message: "Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist", conversationID: 10, chatSequence: 1, isUserMessage: false, dateCreated: .now)
        MessageView(chat: chat)
    }
}
