//
//  AnimateableText.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/22/23.
//

import SwiftUI

struct AnimatableText: View {
    @State var isAnimating: Bool
    
    private var letters: [String]{
        text.map{ String($0) }
    }
    private var fraction: CGFloat{
        1 / CGFloat(letters.count)
    }
    let text: String
     
    init(text: String) {
        self.isAnimating = false
        self.text = text
    }
    
    var body: some View {
        FlexibleStack(spacing: 0, alignment: .leading){
            ForEach(letters.indices, id: \.self) { index in
                Text(letters[index])
                    .foregroundStyle(.white)
                    .font(.title3)
                    .modifier(PresentingTextModifer(isAnimating: isAnimating, fraction: fraction, order: index))
                    .modifier(PresentingTextOpacityModifer(isAnimating: isAnimating, fraction: fraction, order: index))
            }
        }
        .onAppear{
            withAnimation(.easeInOut(duration: Double(self.letters.count) * 0.025).delay(0.8)) {
                isAnimating.toggle()
            }
        }
    }
}

#Preview {
    AnimatableText(text: "lorem Ipsum Test IsOn Last time we talk, you were sad about Llorem ipsum dolor sit amet consectetur. Tempus dui vitae vivamus diam habitasse metus aliquet rhoncus. Potenti nulla pulvinar neque tellus lectus sit.")
}
