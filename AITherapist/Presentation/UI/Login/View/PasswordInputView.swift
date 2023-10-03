//
//  PasswordInputView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/18/23.
//

import SwiftUI

struct PasswordInputView: View {
    @State var text: String
    @State private var fieldOpacity: Double = 0
    @State private var xOffset: Double = 50
    
    var body: some View {
        TextField("Password", text: $text, axis: .vertical)
            .padding(10)            
            .background(ColorPallet.blueUserMessage)
            .textContentType(.password)
            .cornerRadius(15)
            .opacity(fieldOpacity)
            .offset(x: xOffset)
            .onAppear{
                withAnimation(.linear(duration: 1).delay(0.5)) {
                    fieldOpacity = 1
                }
                
                withAnimation(.linear(duration: 1).delay(0.5)){
                    xOffset = 0
                }
            }
    }
}

struct PasswordInputView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordInputView(text: "")
    }
}
