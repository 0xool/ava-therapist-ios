//
//  JournalSavedView.swift
//  AITherapist
//
//  Created by cyrus refahi on 1/20/24.
//

import SwiftUI

extension JournalView {
    struct JournalSavedView: View {
        @Binding var show: Bool
        let onChatClicked: () -> ()
        let onAllJournalsClicked: () -> ()
        
        var body: some View {
            VStack{
                Spacer()
                Text("Journal saved!")
                    .font(
                        Font.custom("SF Pro Text", size: 17)
                            .weight(.semibold)
                    )
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                
                Text("Well done on taking a moment to reflect and write. \n\nKeep it up!")
                    .font(
                        Font.custom("SF Pro Display", size: 28)
                            .weight(.bold)
                    )
                    .kerning(0.36)
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                    .frame(width: 279, alignment: .top)
                
                Spacer()
                
                Button {
                    self.show.toggle()
                    self.onChatClicked()
                } label: {
                    // Bold/Callout
                    Text("Start a chat")
                      .font(
                        Font.custom("SF Pro Text", size: 16)
                          .weight(.semibold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(ColorPallet.TertiaryYellow)
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 5)
                .frame(height: 54, alignment: .center)
                .background(ColorPallet.DarkGreen)
                .cornerRadius(50)
                
                Button {
                    self.show.toggle()
                    self.onAllJournalsClicked()
                } label: {
                    // Bold/Callout
                    // Bold/Hyperlinked/Footnote
                    Text("All journals")
                      .font(
                        Font.custom("SF Pro Text", size: 13)
                          .weight(.bold)
                      )
                      .underline()
                      .multilineTextAlignment(.center)
                      .foregroundColor(ColorPallet.DeepAquaBlue)
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 5)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorPallet.LightSkyBlue)
            .ignoresSafeArea()
            
        }
    }
}

#Preview {
    JournalView.JournalSavedView(show: Binding.constant(true), onChatClicked: {
        print("On chat clicked")
    }, onAllJournalsClicked: {
        print("On all journals clicked")
    })
}
