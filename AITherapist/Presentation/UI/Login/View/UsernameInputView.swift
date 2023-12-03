//
//  UsernameInputView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/18/23.
//

import SwiftUI

struct UsernameInputView: View {
    @State var text: String
    @State private var fieldOpacity: Double = 0
    @State private var xOffset: Double = 50
    
    var body: some View {
        TextField("Username", text: $text, axis: .vertical)
            .padding(10)
            .background(ColorPallet.blueUserMessage)
            .opacity(fieldOpacity)
            .offset(x: xOffset)
            .cornerRadius(15)
            .onAppear{
                withAnimation(.linear(duration: 1)) {
                    fieldOpacity = 1
                }
                
                withAnimation(.linear(duration: 1)){
                    xOffset = 0
                }
            }
        
    }
}

struct UsernameInputView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameInputView(text: "")
    }
}
