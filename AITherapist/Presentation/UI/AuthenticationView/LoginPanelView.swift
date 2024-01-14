//
//  LoginPanelView.swift
//  AITherapist
//
//  Created by cyrus refahi on 12/22/23.
//

import SwiftUI

struct LoginPanelView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var showCreateAcount: Bool
    
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    
    let onGoogleLoginClicked: () -> ()
    let onFacebookLoginClicked: () -> ()
    let onLoginClicked: () -> ()
    
    private let thirdPartyIconSize: CGFloat = 40
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("Welcome Back")
                .fontWeight(.bold)
                .foregroundColor(ColorPallet.DarkGreen)
            
            Spacer()
            
            LoginInputView
            
            Spacer()
                .frame(maxHeight: 50)
            
            loginBtnView
            
            Spacer()
            
            thirdPartyLoginBtnView
            
            Spacer()
            
            newToAvaView
        }.onTapGesture {
            self.hideKeyboard()
        }
        
        .background(background)
    }
    
    @ViewBuilder var background: some View {
        AuthenticationBackgroundView()
    }
    
    @ViewBuilder var loginBtnView: some View{
        Button(action: {
            onLoginClicked()
        }, label: {
            Text("Login")
                .font(
                    Font.custom("SF Pro Text", size: 16)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(ColorPallet.TextYellow)
        })
        .padding(.horizontal, 50)
        .padding(.vertical, 5)
        .frame(height: 54, alignment: .center)
        .background(ColorPallet.DarkGreen)
        .cornerRadius(50)
    }
    
    @ViewBuilder var LoginInputView: some View{
        VStack(alignment: .center, spacing: 15) {
            TextField("Email Adress", text: $email)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .frame(width: 276, alignment: .leading)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: nil, height: 1, alignment: .bottom)
                        .foregroundColor(ColorPallet.DarkGreen)
                        .shadow(color: ColorPallet.DarkGreen, radius: 1, x: 0, y: 1), alignment: .bottom
                )
        }
        .padding(0)
        
        VStack(alignment: .center, spacing: 15) {
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .frame(width: 276, alignment: .leading)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).frame(width: nil, height: 1, alignment: .bottom).foregroundColor(ColorPallet.DarkGreen).shadow(color: ColorPallet.DarkGreen, radius: 1, x: 0, y: 1), alignment: .bottom)
            
        }
        .padding(0)
    }
    
    @ViewBuilder var thirdPartyLoginBtnView: some View {
        HStack(spacing: 50) {
            
            Image("GoogleIcon")
                .frame(width: thirdPartyIconSize, height: thirdPartyIconSize)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(
                    Circle()
                        .fill(ColorPallet.Celeste)
                        .padding(1)
                )
            
            Image("FacebookIcon")
                .frame(width: thirdPartyIconSize, height: thirdPartyIconSize)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(
                    Circle()
                        .fill(ColorPallet.Celeste)
                        .padding(1)
                )
            
            Image(systemName: "apple.logo")
                .font(.title)
                .frame(width: thirdPartyIconSize, height: thirdPartyIconSize)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(
                    Circle()
                        .fill(ColorPallet.Celeste)
                        .padding(1)
                )
        }
        .padding(0)
    }
    
    @ViewBuilder var newToAvaView: some View {
        Button(action: {
            showCreateAcount.toggle()
        }, label: {
            VStack(alignment: .center, spacing: 5) {
                Text("New to Ava?")
                    .font(Font.custom("SF Pro Text", size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.DarkGreen)
                
                Text("Sign up for free")
                    .font(Font.custom("SF Pro Display", size: 15))
                    .underline()
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.DarkGreen)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(0)
        })
    }
    
}

#Preview {
    LoginPanelView(email: Binding.constant(""), password: Binding.constant(""), showCreateAcount: Binding.constant(true), onGoogleLoginClicked: {}, onFacebookLoginClicked: {}, onLoginClicked: {})
}
