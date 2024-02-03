//
//  SettingView.swift
//  AITherapist
//
//  Created by cyrus refahi on 1/30/24.
//

import SwiftUI

struct SettingView: View {
    @State var personality: Int = 2
    @State var showNotification: Bool = false
    
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
    
    var body: some View {
        VStack{
            HStack{
                Text("AI Personality")
                
                Spacer()
               
                Picker(selection: $personality, label: Text("AI Personality")) {
                    Text("1")
                        .tag(1)
                    Text("2")
                        .tag(2)
                }
            }
            .padding()
            
            Divider()
            
            HStack{
                Text("Notification")
                
                Spacer()
                
                Toggle("", isOn: $showNotification)
            }
            .padding()
            
            Button(action: {
                
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

#Preview {
    SettingView()
}
