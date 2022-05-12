//
//  BannerViewModel.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 20.03.22.
//

import Foundation
import UserNotifications


class NotificationManager: ObservableObject {
    
    // https://www.youtube.com/watch?v=mG9BVAs8AIo
    
    static let instance = NotificationManager() // singelton
    
    var reminderInXMinutes: Double = 2.0
    var reminderTitle: String = ""
    var reminderSubTitle: String = ""
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR \(error)")
            } else {
                print("NOTIFICATION PERMISSION SUCCESS")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "This is my first notificaiont!"
        content.subtitle = "This was soooo easy!"
        content.sound = .default
        content.badge = 1
        
        // time trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderInXMinutes, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("Added notification request")
    }
}
