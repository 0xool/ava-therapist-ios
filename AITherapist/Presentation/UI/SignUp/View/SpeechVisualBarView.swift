//
//  SpeechVisualBarView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import SwiftUI

struct SpeechVisualBarView: View {
    var value: CGFloat
    let numberOfSamples: Int = 30
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [.white, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 10) / CGFloat(numberOfSamples), height: value)
        }
    }
}

struct SpeechVisualBarView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechVisualBarView(value: 10)
    }
}
