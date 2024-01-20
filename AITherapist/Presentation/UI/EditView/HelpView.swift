//
//  EditView.swift
//  AITherapist
//
//  Created by cyrus refahi on 1/15/24.
//

import SwiftUI

struct EditView: View {
    private var formSize: (width: CGFloat, height: CGFloat) {
        get{
            return (viewSize.width, viewSize.height * 0.7)
        }
    }
    
    private var viewSize: (width: CGFloat, height: CGFloat) {
        get{
            return (CGFloat(UIViewController().view.bounds.width), CGFloat(UIViewController().view.bounds.height))
        }
    }
    
    @State var fullNameText = ""
    @State var emailText = ""
    @State var phoneText = ""
    
    @State var subject = ""
    @State var message = ""
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(ColorPallet.Celeste)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .backgroundStyle(ColorPallet.Celeste)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 30)
                .fill(ColorPallet.Verdigris)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: viewSize.height / 2)
                
            Image("EarBG")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                VStack{
                    Text("Contact us")
                        .bold()
                        .font(.title)
                        .kerning(0.38)
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorPallet.DarkGreen)
                        .frame(alignment: .top)
                        .padding(.bottom, 16)
                    
                    // Regular/Body
                    Text("Please fill out the form and we get back to you ASAP.")
                        .font(Font.custom("SF Pro Text", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(alignment: .top)
                        .padding(.bottom, 32)
                    
                    TextFieldView(textField: $fullNameText, filedName: "Full name*")
                    TextFieldView(textField: $fullNameText, filedName: "Email address*")
                    TextFieldView(textField: $fullNameText, filedName: "Phone number*")
                    
                    TextFieldView(textField: $fullNameText, filedName: "Subject*")
                    MessageFieldView(textField: $fullNameText, filedName: "Message*")
                        .frame(maxHeight: .infinity)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Submit")
                            .font(.callout)
                            .foregroundStyle(ColorPallet.Celeste)
                    })
                    .padding(.horizontal, 30)
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
                    .background(ColorPallet.DeepAquaBlue)
                    .cornerRadius(50)
                }
                .padding()
            }
            .frame(height: formSize.height)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.25), radius: 3.5, x: 4, y: 6)
            .padding()
        }
        .backgroundStyle(ColorPallet.Celeste)
        
    }
}

extension EditView{
    struct TextFieldView: View {
        @Binding var textField: String
        let filedName: String
        
        var body: some View {
            TextField(filedName, text: $textField)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(Color(red: 0.66, green: 0.66, blue: 0.66), lineWidth: 1)
            )
        }
    }
    
    struct MessageFieldView: View {
        @Binding var textField: String
        let filedName: String
        
        var body: some View {
            HStack(alignment: .center, spacing: 10) {
                TextField(filedName, text: $textField)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(10)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(Color(red: 0.66, green: 0.66, blue: 0.66), lineWidth: 1)
            )
        }
    }
}

#Preview {
    EditView()
}
