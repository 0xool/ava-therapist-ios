//
//  RegisterPanelView.swift
//  AITherapist
//
//  Created by cyrus refahi on 12/26/23.
//

import SwiftUI

struct RegisterPanelView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var rePassword: String
    
    @Binding var showLogin: Bool
    
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    
    let onGoogleLoginClicked: () -> ()
    let onFacebookLoginClicked: () -> ()
    let onRegisterClicked: () -> ()

    var body: some View {
        VStack{
            Spacer()
            
            VStack(spacing: 28){
                // Bold/Headline
                Text("Create an account")
//                  .font(
//                    Font.custom("SF Pro Text", size: 24)
//                      .weight(.heavy)
//                  )
                  .fontWeight(.bold)
//                  .multilineTextAlignment(.center)
                  .foregroundColor(ColorPallet.DarkGreen)
                
                Text(" Boost your experience with more chats, personalized tracking, and insights!")
                  .font(Font.custom("SF Pro Text", size: 17))
                  .multilineTextAlignment(.center)
                  .foregroundColor(ColorPallet.DarkGreen)
            }
            
            Spacer()
            
            registerInputView
            
            Spacer()
                .frame(maxHeight: 50)
            
            registerBtnView
            
            Spacer()
            //                .frame(maxHeight: 50)
            
            thirdPartyRegisterBtnView
            
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
    
    @ViewBuilder var registerBtnView: some View{
        Button(action: {
            onRegisterClicked()
        }, label: {
            Text("Next")
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
    
    @ViewBuilder var registerInputView: some View{
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
                
        VStack(alignment: .center, spacing: 15) {
            SecureField("Repeat Password", text: $rePassword)
                .textContentType(.password)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .frame(width: 276, alignment: .leading)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).frame(width: nil, height: 1, alignment: .bottom).foregroundColor(ColorPallet.DarkGreen).shadow(color: ColorPallet.DarkGreen, radius: 1, x: 0, y: 1), alignment: .bottom)

        }
        .padding(0)
    }
    
    @ViewBuilder var thirdPartyRegisterBtnView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                Image("GoogleIcon")
                    .frame(width: 33, height: 34)
                // Regular/Footnote
                Text("Continue with Google")
                    .font(Font.custom("SF Pro Text", size: 13))
                    .foregroundColor(ColorPallet.DarkGreen)
                    .padding(.horizontal, 0)
                    .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .frame(width: 296, alignment: .leading)
            .background(ColorPallet.Celeste)
            .cornerRadius(5)
            
            HStack(alignment: .center, spacing: 0) {
                Image("FacebookIcon")
                    .frame(width: 33, height: 34)
                
                // Regular/Footnote
                Text("Continue with Facebook")
                    .font(Font.custom("SF Pro Text", size: 13))
                    .foregroundColor(ColorPallet.DarkGreen)
                    .padding(.horizontal, 0)
                    .padding(.leading, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .frame(width: 296, alignment: .leading)
            .background(ColorPallet.Celeste)
            .cornerRadius(5)
        }
        .padding(0)
    }
    
    @ViewBuilder var newToAvaView: some View {
        Button(action: {
            showLogin.toggle()
        }, label: {
            Text("Already have an acount?")
                .font(Font.custom("SF Pro Display", size: 15))
                .underline()
                .multilineTextAlignment(.center)
                .foregroundColor(ColorPallet.DarkGreen)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(0)
        })
    }
}

#Preview {
    RegisterPanelView(email: Binding.constant(""), password: Binding.constant(""), rePassword: Binding.constant(""), showLogin: Binding.constant(false), onGoogleLoginClicked: {}, onFacebookLoginClicked: {}, onRegisterClicked: {})
}
