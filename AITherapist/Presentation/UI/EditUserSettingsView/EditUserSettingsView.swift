//
//  EditUserSettingsView.swift
//  AITherapist
//
//  Created by cyrus refahi on 1/21/24.
//

import SwiftUI

struct EditUserSettingsView: View {
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
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    init( viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            Text("Edit User Info")
                .bold()
                .font(.title)
                .kerning(0.38)
                .multilineTextAlignment(.center)
                .foregroundColor(ColorPallet.DarkGreen)
                .frame(alignment: .top)
                .padding([.bottom, .top], 16)
            
            VStack(alignment: .center, spacing: 0){
                TextFieldView(textField: $viewModel.username, filedName: "Username")
                TextFieldView(textField: $viewModel.name, filedName: "Name")
                TextFieldView(textField: $viewModel.lastname, filedName: "Lastname")
            }
            
            Button(action: {
                self.hideKeyboard()
                self.viewModel.saveUserInfo()
            }, label: {
                Text("Submit")
                    .font(.callout)
                    .foregroundStyle(ColorPallet.Celeste)
            })
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
            .background(ColorPallet.DeepAquaBlue)
            .cornerRadius(50)
            .padding(.bottom, 16)
            .padding([.leading, .trailing], 16)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.25), radius: 3.5, x: 4, y: 6)
        .padding()
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

extension EditUserSettingsView{
    struct TextFieldView: View {
        @Binding var textField: String
        let filedName: String
        
        var body: some View {
            VStack(spacing: 0){
                Text("\(filedName):")
                    .foregroundStyle(ColorPallet.SolidDarkGreen)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField(text: $textField) {
                    
                }
                .foregroundStyle(ColorPallet.SolidDarkGreen)
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
            .padding()
        }
    }
}

extension EditUserSettingsView{
    class ViewModel: ObservableObject {
        @Published var username: String = "John123"
        @Published var name: String = "John"
        @Published var lastname: String = "Doe"
                
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            
            self.username = container.appState[\.userData].user.value?.userName ?? ""
            self.name = container.appState[\.userData].user.value?.name ?? ""
            self.lastname = container.appState[\.userData].user.value?.lastName ?? ""
        }
        
        func saveUserInfo(){
            self.container.services.profileService.updateUserInfo(username: self.username, name: self.name, lastname: self.lastname)
        }
    }
}

#Preview {
    EditUserSettingsView(viewModel: .init(container: .preview))
}
