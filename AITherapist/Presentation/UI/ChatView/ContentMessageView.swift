//
//  ContentMessageView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import SwiftUI

struct ContentMessageView: View {
    var contentMessage: String
    var isUser: Bool
    let animateText: Bool
    
    @State var animate: Bool
    
    init(contentMessage: String, isUser: Bool, withAnimation: Bool = false, animateText: Bool = false) {
        self.contentMessage = contentMessage
        self.isUser = isUser
        self.animate = !withAnimation
        self.animateText = animateText
    }
    
    var body: some View {
        messageTextView
            .font(Font.custom("SF Pro Text", size: 17)
                .weight(.regular))
            .padding(10)
            .foregroundColor(isUser ? ColorPallet.DarkBlue : .white)
            .background(isUser ? ColorPallet.Celeste : ColorPallet.DeepAquaBlue )
            .clipShape(isUser ? .rect(
                topLeadingRadius: 5,
                bottomLeadingRadius: 15,
                bottomTrailingRadius: 1,
                topTrailingRadius: 15
            ) : .rect(
                topLeadingRadius: 15,
                bottomLeadingRadius: 1,
                bottomTrailingRadius: 15,
                topTrailingRadius: 5
            ))
            .scaleEffect(animate ? 1 : 0)
            .offset(y: animate ? 0 : -4)
            .onAppear{
                withAnimation{
                    self.animate = true
                }
            }
    }
    
    @ViewBuilder var messageTextView: some View {
        if self.animateText {
            ZStack(alignment: .topLeading){
                TypeWriterView(contentMessage, speed: 0.03)
                Text(contentMessage)
                    .opacity(0)
            }
        }else{
            Text(contentMessage)
        }
    }
}

struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMessageView(contentMessage: "Hi, I am your AITherapist",isUser: false, animateText: false)
    }
}
