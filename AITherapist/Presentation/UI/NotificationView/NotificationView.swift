//
//  NotificationView.swift
//  AITherapist
//
//  Created by cyrus refahi on 7/19/24.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State var currentSelectedDate: NotificationTime = .Evening
    
    var body: some View {
        VStack{
            Spacer()

            VStack(spacing: 10)
            {
                Text("Choose a daily check-in time")
                    .bold()
                    .font(Font.custom("SF Pro Text", size: 25))
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                
                Text("Checking in daily will maximize our progress together.")
                    .font(Font.custom("SF Pro Text", size: 15))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .frame(height: 150)
            
            Spacer()
            
            VStack(spacing: 8){
                    morningButtonNotifView
                    afternoonButtonNotifView
                    eveningButtonNotifView
                    nightButtonNotifView
            }
            
            Spacer()
            
            Button(action: {
                self.hideKeyboard()
                self.viewModel.onNotifDateSelected( self.currentSelectedDate)
            }, label: {
                Text("Let's do it")
                    .font(
                        Font.custom("SF Pro Text", size: 16)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.TextYellow)
            })
            .padding(.horizontal, 50)
            .padding(.vertical, 5)
            .frame(height: 54, alignment: .center)
            .background(ColorPallet.DarkGreen)
            .cornerRadius(50)
            
            Spacer()
            
            Button {
                self.viewModel.onNotificationSet()
            } label: {
                Text("Skip for now")
                    .font(
                    Font.custom("SF Pro Text", size: 13)
                    .weight(.bold)
                    )
                    .underline()
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.DiaryDateBlue)
            }
            .padding(.bottom, 50)
            .frame(height: 100)
            .frame(maxWidth: .infinity)

        }
        .background(background)
        
    }
    
    @ViewBuilder var morningButtonNotifView: some View {
        Button{
            self.currentSelectedDate = .Morning
        } label: {
            HStack{
                Image(systemName: "sun.min.fill")
                    .padding(.leading)
                VStack(alignment: .leading){
                    Text("Morning")
                        .font(Font.custom("SF Pro Text", size: 9))
                        .foregroundColor(self.currentSelectedDate == .Morning ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                    
                    Text("08:00 AM - 12:00 PM")
                        .font(Font.custom("SF Pro Text", size: 8))
                        .foregroundColor(self.currentSelectedDate == .Morning ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                }
                Spacer()
            }
        }
        .frame(height: 75)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(ColorPallet.SolidDarkGreen, lineWidth: 1)
        )
        .background(self.currentSelectedDate == .Morning ? ColorPallet.SolidDarkGreen : nil)
        .padding(.horizontal, 8)

    }
    
    @ViewBuilder var eveningButtonNotifView: some View {
        Button{
            self.currentSelectedDate = .Evening
        } label: {
            HStack{
                Image(systemName: "sun.min.fill")
                    .padding(.leading)
                VStack(alignment: .leading){
                    Text("Evening")
                        .font(Font.custom("SF Pro Text", size: 9))
                        .foregroundColor(self.currentSelectedDate == .Evening ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                    
                    Text("05:00 AM - 08:00 PM")
                        .font(Font.custom("SF Pro Text", size: 8))
                        .foregroundColor(self.currentSelectedDate == .Evening ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                }
                Spacer()
            }
            .frame(height: 75)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(ColorPallet.SolidDarkGreen, lineWidth: 1)
            )
            .background(self.currentSelectedDate == .Evening ? ColorPallet.SolidDarkGreen : nil)
            .padding(.horizontal, 8)
        }

    }
    
    @ViewBuilder var afternoonButtonNotifView: some View {
        Button{
            self.currentSelectedDate = .Afternoon
        } label: {
            HStack{
                Image(systemName: "sun.min.fill")
                    .padding(.leading)
                VStack(alignment: .leading){
                    Text("Afternoon")
                        .font(Font.custom("SF Pro Text", size: 9))
                        .foregroundColor(self.currentSelectedDate == .Afternoon ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                    
                    Text("12:00 PM - 05:00 PM")
                        .font(Font.custom("SF Pro Text", size: 8))
                        .foregroundColor(self.currentSelectedDate == .Afternoon ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                }
                Spacer()
            }
            .frame(height: 75)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(ColorPallet.SolidDarkGreen, lineWidth: 1)
            )
            .background(self.currentSelectedDate == .Afternoon ? ColorPallet.SolidDarkGreen : nil)
            .padding(.horizontal, 8)
        }

    }
    
    @ViewBuilder var nightButtonNotifView: some View {
        Button{
            self.currentSelectedDate = .Night
        } label: {
            HStack{
                Image(systemName: "sun.min.fill")
                    .padding(.leading)
                VStack(alignment: .leading){
                    Text("Night")
                        .font(Font.custom("SF Pro Text", size: 9))
                        .foregroundColor(self.currentSelectedDate == .Night ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                    
                    Text("08:00 PM - 12:00 AM")
                        .font(Font.custom("SF Pro Text", size: 8))
                        .foregroundColor(self.currentSelectedDate == .Night ? ColorPallet.Celeste : ColorPallet.SolidDarkGreen)
                }
                Spacer()
            }
        }
        .frame(height: 75)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(ColorPallet.SolidDarkGreen, lineWidth: 1)
        )
        .background(self.currentSelectedDate == .Night ? ColorPallet.SolidDarkGreen : nil)
        .padding(.horizontal, 8)

    }
    
    @ViewBuilder var background: some View {
        AuthenticationBackgroundView()
    }
}


extension NotificationView{
    class ViewModel: ObservableObject{
        @Binding var notificationViewSeen: Bool

        init(notificationViewSeen: Binding<Bool>) {
            self._notificationViewSeen = notificationViewSeen
            
            NotificationManager.instance.requestNotifAuthorization{
                
            } onFailiure: {
                self.notificationViewSeen = true
            }

        }
        
        func onNotifDateSelected(_ time: NotificationTime) {
            NotificationManager.instance.scheduelNotification(time)
            onNotificationSet()
        }
        
        func onNotificationSet() {
            PersistentManager.instance.saveNotificationSeen()
            self.notificationViewSeen = true
        }
    }
}

#Preview {
    NotificationView(viewModel: .init(notificationViewSeen: .constant(false)))
}
