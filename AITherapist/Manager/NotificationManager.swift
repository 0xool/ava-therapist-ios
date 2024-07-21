//
//  NotificationManager.swift
//  AITherapist
//
//  Created by cyrus refahi on 7/20/24.
//

import Foundation
import SwiftUI

protocol NotificationProtocol {
    func requestNotifAuthorization(onSuccess: @escaping () -> (), onFailiure: @escaping () -> ())
    func scheduelNotification()
}

class NotificationManager: NotificationProtocol {
    static let instance: NotificationManager = NotificationManager()
    
    func requestNotifAuthorization(onSuccess: @escaping () -> (), onFailiure: @escaping () -> ()) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("ERROR: \(error)")
                onFailiure()
//                hasEnabledNotif = false
            }else{
                print("SUCCESS")
                onSuccess()
//                self.scheduelNotification()
//                hasEnabledNotif = true
            }
        }
    }
    
    func scheduelNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Notification"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}


extension NotificationManager {
    enum NotificationTime: String {
        case Morning = "Morning"
        case Afternoon = "Afternoon"
        case Evening = "Evening"
        case Night = "Night"
    }
}
