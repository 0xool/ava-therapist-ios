//
//  AvaNavBarView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Foundation
import SwiftUI

struct AvaNavBarView<Content: View, Background: View>: View {
    @State private var showHelpLine: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var backButtonType: TopLeftButtonType = .nothing
    
    @State private var title: String = ""
    @State private var isChatBar: Bool = false
    
    let content: Content
    let background: Background
    
    init (@ViewBuilder content: () -> Content, @ViewBuilder background: () -> Background){
        self.content = content()
        self.background = background()
    }
    
    var body: some View {
        ZStack{
            self.background
            VStack{
                NavBar()
                    .backgroundStyle(.clear)
                    .padding(.top, 4)
                self.content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .backgroundStyle(.clear)
            }
        }
        .fullScreenCover(isPresented: self.$showHelpLine, content: {
            HelpLineView {
                self.showHelpLine = false
            }
        })
        .toolbarBackground(.hidden, for: .navigationBar)
        .backgroundStyle(.clear)
        .onPreferenceChange(AvaNavigationBarTopLeftButtonRefrenceKeys.self, perform: { self.backButtonType = $0 })
        .onPreferenceChange(AvaNavigationBarTitleRefrenceKeys.self) { self.title = $0 }
        .onPreferenceChange(AvaNavigationBarColorRefrenceKeys.self) { self.isChatBar = $0 }
    }
    
    @ViewBuilder var helpLineView: some View {
        ZStack{
            Text("Helplines")
            .font(
            Font.custom("SF Pro Text", size: 12)
            .weight(.medium)
            )
            .foregroundColor(.white)
                .foregroundStyle(Color(red: 0.71, green: 0.99, blue: 0.99))
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
                            .foregroundStyle(self.isChatBar ? ColorPallet.Celeste : ColorPallet.IconBlue)
                            .padding([.leading], 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                case .logOut:
                    Button {
                        dismiss()
                        AppState.UserData.shared.logout()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title3)
                            .foregroundStyle(ColorPallet.SolidDarkGreen)
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
            
            helpLineView
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    self.showHelpLine = true
                }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: UIScreen.main.bounds.width, height: 40)
    }
    
    @ViewBuilder var middleSection: some View{
        if self.title.isEmpty {
            LogoIcon(isChatBar: self.isChatBar)
        }else{
            Text(title)
                .font(
                Font.custom("SF Pro Display", size: 20)
                .weight(.semibold)
                )
                .kerning(0.38)
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
    } background: {
        TwoCircleBackgroundView()
    }
}
