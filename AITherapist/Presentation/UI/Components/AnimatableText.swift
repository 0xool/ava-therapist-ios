//
//  AnimateableText.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/22/23.
//

import SwiftUI

struct AnimatableText: View {
    @State var isAnimating: Bool
    
    private var words: [String]{
        text.components(separatedBy: " ")
    }
    private var fraction: CGFloat{
        1 / CGFloat(words.count)
    }
    
    private var textSize: CGFloat {
        CGFloat(words.count)
    }
    
    let text: String
    let animationTime: CGFloat
    init(text: String, animationTime: CGFloat = 4) {
        self.isAnimating = false
        self.text = text
        self.animationTime = animationTime
    }
    
    var body: some View {
        FlexibleStack(spacing: 4){
            ForEach(words.indices, id: \.self) { index in
                AnimatableWord(word: words[index], delay: (CGFloat(index) / textSize) * animationTime)
            }
        }
    }
}

struct AnimatableWord: View {
    @State var isAnimating: Bool
    
    private var letters: [String]{
        word.map{ String($0) }
    }
    private var fraction: CGFloat{
        1 / CGFloat(letters.count)
    }
    private let initalDelay: CGFloat = 1
    
    let delay: CGFloat
    let word: String
    init(word: String, delay: CGFloat) {
        self.isAnimating = false
        self.word = word
        self.delay = delay
    }
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(letters.indices, id: \.self) { index in
                Text(letters[index])
                    .foregroundStyle(ColorPallet.DarkBlue)
                    .bold()
                    .modifier(PresentingTextModifer(isAnimating: isAnimating, fraction: fraction, order: index))
                    .modifier(PresentingTextOpacityModifer(isAnimating: isAnimating, fraction: fraction, order: index))
            }
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 0.5).delay(initalDelay + delay)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    AnimatableText(text: "lorem Ipsum Test IsOn Last time we talk, you were sad about Llorem ipsum dolor sit amet consectetur. Tempus dui vitae vivamus diam habitasse metus aliquet rhoncus. Potenti nulla pulvinar neque tellus lectus sit.")
}
