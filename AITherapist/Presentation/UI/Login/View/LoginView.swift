//
//  LoginView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/10/23.
//

import SwiftUI

struct LoginView: View {
    @State var usernameText: String = ""
    @State var passwordText: String = ""
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(spacing: 25) {
                Text("AiTherapist")
                UsernameInputView(text: usernameText)
                    .frame(width: geo.size.width * 0.8)
                PasswordInputView(text: passwordText)
                    .frame(width: geo.size.width * 0.8)
                HStack{
                    loginBtnView(geo)
//                    loginAsGuestBtnView(geo)
                }
                
                signUpBtnView(geo)
            }
            .frame(width: geo.size.width , height: geo.size.height)
            .background(ColorPallet.greenBackground)
        }
        
    }
    
    private func loginBtnView(_ geo: GeometryProxy) -> some View {
        AuthenticationButton(delay: 0.25)  {
            
        } btnLabel: {
            ZStack{
                Rectangle()
                    .frame(width: geo.size.width * 0.8, height: 50)
                    .cornerRadius(20)
                Text("Login")
                    .foregroundColor(.white)
            }
        }
    }
    
    private func signUpBtnView(_ geo: GeometryProxy) -> some View {
        AuthenticationButton(delay: 0.25) {
            
        } btnLabel: {
            ZStack{
                Rectangle()
                    .fill(ColorPallet.greenAiMessage)
                    
                    .frame(width: geo.size.width * 0.8, height: 50)
                    .cornerRadius(20)

                Text("Sign Up")
                    .foregroundColor(.white)
            }
        }
    }
    
}

struct AuthenticationButton<Content: View>: View {
    
    @State private var opacity: Double = 0
    
    var delay: Double = 0
    var buttonAction: () -> ()
    @ViewBuilder var btnLabel: () -> Content
    
    var body: some View {
        Button {
            buttonAction()
        } label: {
            btnLabel()
        }
        .opacity(opacity)
        .onAppear{
            withAnimation(.linear(duration: 1).delay(delay)) {
                opacity = 1
            }
        }
        

    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
