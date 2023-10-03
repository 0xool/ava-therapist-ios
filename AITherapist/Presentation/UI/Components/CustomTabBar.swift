//
//  CustomTabView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI

struct CustomTabBar: View {
    var body: some View {
        HStack(alignment: .center) {
            Button {
                
            } label: {
                GeometryReader { geo in
                    VStack (alignment: .center, spacing: 4){
                        Image(systemName: "figure.mind.and.body")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Insight")
                            .font(.system(size: 12))
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            
            Button {
                
            } label: {
                GeometryReader { geo in
                    VStack (alignment: .center, spacing: 4){
                        ZStack{
                            Circle()
                                .frame(width: 40, height: 40)

                                .foregroundColor(.green)
                                
                            Image(systemName: "bubble.middle.bottom.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                        
                        Text("Chat")
                            .font(.system(size: 12))
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            
            
            Button {
                
            } label: {
                GeometryReader { geo in
                    VStack (alignment: .center, spacing: 4){
                        Image(systemName: "camera.macro")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Meditation")
                            .font(.system(size: 12))
                            
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 75)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}
