//
//  NotificationView.swift
//  AITherapist
//
//  Created by cyrus refahi on 7/19/24.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        Text("Hello, World!")
        VStack
        {
            Text("Choose ")
            Text("asd asd")
        }
        
        Spacer()
        
    }
}


extension NotificationView{
    class ViewModel: ObservableObject{
        @Binding var notificationViewSeen: Bool

        init(notificationViewSeen: Binding<Bool>) {
            self._notificationViewSeen = notificationViewSeen
            
            NotificationManager.instance.requestNotifAuthorization {
                
            } onFailiure: {
                self.notificationViewSeen = true
            }

        }
        
        func onNotificationSet() {
            PersistentManager.saveNotificationSeen()
            self.notificationViewSeen = true
        }
    }
}

#Preview {
    NotificationView(viewModel: .init(notificationViewSeen: .constant(false)))
}
