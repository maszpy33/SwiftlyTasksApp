//
//  BannerView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 20.03.22.
//

import SwiftUI
import UserNotifications


struct NotificationView: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Request permission") {
//                NotificationManager.instance.requestAuthorization()
                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
                    if let error = error {
                        print("ERROR \(error)")
                    } else {
                        print("NOTIFICATION PERMISSION SUCCESS")
                    }
                }
            }
            
            Button("Schedule notification") {
//                NotificationManager.instance.scheduleNotification()
                let content = UNMutableNotificationContent()
                content.title = "This is my first notificaiont!"
                content.subtitle = "This was soooo easy!"
                content.sound = UNNotificationSound.default
                
                // time trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
                print("Added notification request")
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
