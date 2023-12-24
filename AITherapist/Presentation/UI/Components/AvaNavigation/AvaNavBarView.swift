//
//  AvaNavBarView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Foundation
import SwiftUI

struct AvaNavBarView<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var backButtonType: TopLeftButtonType = .nothing
    @State private var title: String = ""
    
    @State private var showBackground: Bool = false
    let content: Content
    
    init (@ViewBuilder content: () -> Content){
        self.content = content()
    }
    
    var body: some View {
        ZStack{
            TwoCircleBackgroundView(backgroundColor: .white, animate: false)
                .opacity(0.3)
                .hiddenModifier(isHide: !self.showBackground)

            VStack{
                NavBar()
                    .backgroundStyle(.clear)
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .backgroundStyle(.clear)
            }
        }
        .backgroundStyle(.red)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onPreferenceChange(AvaNavigationBarTopLeftButtonRefrenceKeys.self, perform: { self.backButtonType = $0 })
        .onPreferenceChange(AvaNavigationBarTitleRefrenceKeys.self) { self.title = $0 }
        .onPreferenceChange(AvaNavigationBarShowBackgroundRefrenceKeys.self, perform: { self.showBackground = $0 })
    }
    
    @ViewBuilder var HelpLineView: some View {
        ZStack{
            Text("Helplines")
                .foregroundStyle(Color(red: 0.71, green: 0.99, blue: 0.99))
                .font(helpLineFont)
                .padding(8)
        }
        .background{
            RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                .foregroundStyle(ColorPallet.HelpLineColor)

        }
        .padding(8)
    }
    
    func NavBar() -> some View {
        ZStack(alignment: .center){
                switch self.backButtonType {
                case .back:
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                            .padding([.leading], 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                case .logOut:
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title3)
                            .foregroundStyle(.gray)
                            .padding([.leading], 8)
                            .rotation3DEffect( .degrees(180),axis: (x: 0.0, y: 1.0, z: 0.0) )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading], 8)
                
                case .nothing:
                    EmptyView()
                }
            
            middleSection
                .frame(maxWidth: .infinity, alignment: .center)
            
            HelpLineView
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: UIScreen.main.bounds.width, height: 40)
    }
    
    @ViewBuilder var middleSection: some View{
        if self.title.isEmpty {
            LogoIcon()
        }else{
            Text(title)
                .font(
                    Font.custom("SF Pro Display", size: 22)
                        .weight(.bold)
                )
                .kerning(0.35)
                .foregroundColor(.black)
        }
    }
}

public enum TopLeftButtonType {
    case back
    case logOut
    case nothing
}


#Preview{
    AvaNavBarView{
        Color.clear.ignoresSafeArea()
            .avaNavigationBarTitle("Conversations")
            .avaNavigationBarTopLeftButton(.back)
    }
}
