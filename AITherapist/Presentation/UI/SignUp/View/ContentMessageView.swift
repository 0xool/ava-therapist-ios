//
//  ContentMessageView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import SwiftUI

struct ContentMessageView: View {
    var contentMessage: String
    var isUser: Bool
    
    var body: some View {
            Text(contentMessage)
                .padding(10)
                .foregroundColor(isUser ? Color.black : Color.white)
                .background(isUser ? ColorPallet.SecondaryColorBlue : ColorPallet.SecondaryColorGreen)
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
    }
}

struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMessageView(contentMessage: "Hi, I am your AITherapist",isUser: false)
    }
}
