//
//  MessageView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import SwiftUI

struct MessageView : View {
    var currentMessage: Message
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            if !currentMessage.isUser {
                
                ZStack {
                    Circle()
                        .foregroundColor(ColorPallet.aiPortraitColor)
                    .frame(width: 40, height: 40, alignment: .top)
                    Text("Ava")
                        .foregroundColor(.black)
                }
            } else {
                Spacer()
            }
            ContentMessageView(contentMessage: currentMessage.content,
                               isUser: currentMessage.isUser)
        }
        .background(ColorPallet.greenBackground)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        let message = Message(content: "Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist, Hello User I am AITherapist", isUser: false)
        MessageView(currentMessage: message)
    }
}
