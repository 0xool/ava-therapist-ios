//
//  NewChatChoiceView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/17/24.
//

import SwiftUI

struct NewChatChoiceView: View {
    let onBubleClicked: (String) -> ()
    let initialTextList: [String]
    
    init(onBubleClicked: @escaping (String) -> Void, initialTextList: [String] = Constants.InitialChatMessageBubbles) {
        self.onBubleClicked = onBubleClicked
        self.initialTextList = initialTextList
    }
    
    var body: some View {
        FlexibleStack {
            ForEach(initialTextList, id: \.self) { text in
                Text(text)
                    .font(Font.custom("SF Pro Text", size: 10).bold())
                .padding()
                .foregroundStyle(ColorPallet.DarkBlueText)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(red: 0.93, green: 0.94, blue: 0.94))
                )
                .onTapGesture {
                    onBubleClicked(text)
                }
            }
        }
    }
}

#Preview {
    NewChatChoiceView(onBubleClicked: {
        print($0)
    }, initialTextList: ["Don’t know why, but anxious!", "I’m overwhelmed.", "Let’s just talk.", "I'm having a blast"])
}
