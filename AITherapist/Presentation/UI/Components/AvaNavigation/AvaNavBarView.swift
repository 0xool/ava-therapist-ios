//
//  AvaNavBarView.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import Foundation
import SwiftUI

struct AvaNavBarView<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var backButtonIsHidden: Bool = true
    let content: Content
    
    init (@ViewBuilder content: () -> Content){
        self.content = content()
    }
    
    var body: some View {
        VStack{
            NavBar(showBackButton: backButtonIsHidden)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(AvaNavigationBarBackButtonHiddenRefrenceKeys.self, perform: { value in
            self.backButtonIsHidden = value
        })
    }
    
    @ViewBuilder var HelpLineView: some View {
        ZStack{
            Text("Helplines")
                .foregroundStyle(.black)
                .font(helpLineFont)
                .padding(8)
        }
        .background{
            RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                .foregroundStyle(.green)
                
        }
        .padding(8)
    }
    
    func NavBar(showBackButton: Bool) -> some View {
        ZStack {
            HStack(alignment: .center){
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                        .padding([.leading], 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .hiddenModifier(isHide: showBackButton)

                
                LogoIcon()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HelpLineView
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: UIScreen.main.bounds.width, height: 40)
    }
}


#Preview{
    AvaNavBarView{
        Color.blue.ignoresSafeArea()
            .avaNavigationBarBackButtonHidden(true)
    }
}
