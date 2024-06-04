//
//  HelpLineView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/27/24.
//

import SwiftUI

struct HelpLineView: View {
    let onCloseClicked: () -> ()
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    Button {
                        self.onCloseClicked()
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 30, height: 30)
                            .font(Font.system(size: 25))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
            .frame(maxWidth: UIViewController().view.bounds.width, maxHeight: .infinity)
            
            VStack{
                Spacer()
                VStack(spacing: 25){
                    Text("Are you in crisis?")
                      .font(Font.custom("SF Pro Display", size: 20))
                      .kerning(0.38)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                    
                    Text("You are not alone.  Help is just a call away!")
                      .font(
                        Font.custom("SF Pro Text", size: 22)
                          .weight(.bold)
                      )
                      .kerning(0.35)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack{
                    HStack(alignment: .center, spacing: 10) {
                        
                        Button(action: {
                            if let phoneURL = URL(string: "tel://\(Constants.EmergencyPhoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
                                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                            } else {
                                // Handle error, such as unable to make a call
                                print("Cannot make a phone call")
                            }
                        }) {
                            Text("Local Emergency Service")
                              .font(
                                Font.custom("SF Pro Text", size: 16)
                                  .weight(.semibold)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                        }
                        

                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 5)
                    .frame(height: 54, alignment: .center)
                    .background(ColorPallet.DeepAquaBlue)
                    .cornerRadius(50)
                }
                
                Spacer()
                
                VStack(spacing: 10){
                    Text("– Remember –")
                      .font(Font.custom("SF Pro Text", size: 15))
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                    
                    Text("Your feelings are valid.\nYour experiences matter. Things will get better.")
                      .font(
                        Font.custom("SF Pro Display", size: 22)
                          .weight(.bold)
                      )
                      .kerning(0.35)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                }
                Spacer()
            }
            .frame(maxWidth: UIViewController().view.bounds.width, maxHeight: .infinity)
            
            Image("white-ear-bg")
                .resizable()
                .scaledToFill()
                .opacity(0.01)
        }
        .frame(maxWidth: UIViewController().view.bounds.width, maxHeight: .infinity)
        .background(ColorPallet.DarkBlue)
    }
}

#if DEBUG
#Preview {
    HelpLineView(onCloseClicked: {print("Closed")})
}
#endif
