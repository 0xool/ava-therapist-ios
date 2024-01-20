//
//  InviteFriendView.swift
//  AITherapist
//
//  Created by cyrus refahi on 1/20/24.
//

import SwiftUI

struct InviteFriendView: View {
    
    private var formHeight: CGFloat {
        get{
            UIViewController().view.bounds.height * 0.66
        }
    }
    
    var body: some View {
        VStack {
            referFriendForm
            shareOnSocialMediaView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    @ViewBuilder var referFriendForm: some View {
        VStack {
            VStack{
                Spacer()
                Text("Refer friend")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                
                Text("Get credits for free chats")
                    .font(Font.custom("SF Pro Text", size: 17))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                
                Spacer()
                Image("ErrorEar")
                Spacer()
                
                VStack{
                    Text("Copy your code, share it with your friends")
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorPallet.SolidDarkGreen)
                        .frame(width: 210, alignment: .top)
                    
                    HStack(alignment: .center){
                        Text("HKPI098HUO5TH12")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundColor(ColorPallet.SolidDarkGreen)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Copy")
                                .font(
                                    Font.custom("SF Pro Text", size: 16)
                                        .weight(.semibold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(ColorPallet.Celeste)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 0)
                        .frame(height: 40, alignment: .center)
                        .background(ColorPallet.DeepAquaBlue)
                        .cornerRadius(50)
                        
                    }
                    .padding(10)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .inset(by: 0.5)
                            .stroke(ColorPallet.SolidDarkGreen, style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    )
                }
                .padding([.leading, .trailing], 8)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: formHeight)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.25), radius: 3.5, x: 4, y: 6)
        .padding()
    }
    
    @ViewBuilder var shareOnSocialMediaView: some View{
        VStack{
            // Bold/Title3
            Text("Share on social media")
                .font(.footnote)            .multilineTextAlignment(.center)
                .foregroundColor(ColorPallet.SolidDarkGreen)
            
            HStack(spacing: 32){
                instagramIconBtn
                faceBookIconBtn
                twitterIconBtn
            }
        }
    }
    
    @ViewBuilder var instagramIconBtn: some View{
        Image("InstagramIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40, alignment: .center)
    }
    
    @ViewBuilder var faceBookIconBtn: some View{
        Image("FacebookIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40, alignment: .center)
    }
    
    @ViewBuilder var twitterIconBtn: some View{
        Image("TwitterIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40, alignment: .center)
    }
}

#Preview {
    InviteFriendView()
}
