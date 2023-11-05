//
//  AvaNavBarView.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import Foundation
import SwiftUI

struct AvaNavBarView<Content: View>: View {
    
    let content: Content
    
    init (@ViewBuilder content: () -> Content){
        self.content = content()
    }
    
    var body: some View {
        NavBar
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    @ViewBuilder var NavBar: some View {
        ZStack {
            HStack(alignment: .center){
                Button {
                    // Open
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                        .padding([.leading], 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .hidden()
                
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
