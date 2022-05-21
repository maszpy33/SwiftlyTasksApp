//
//  BannerViewModel.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 20.03.22.
//

import Foundation
import UserNotifications


class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    // https://www.youtube.com/watch?v=mG9BVAs8AIo
    
//    static let instance = NotificationManager() // singelton
    
//    var reminderInXMinutes: Double = 2.0
//    var reminderTitle: String = ""
//    var reminderSubTitle: String = ""
    
    @Published var alert = false
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "REPLY" {
            print("reply the comment or do anything")
            self.alert.toggle()
        }
        
        completionHandler()
    }
    
    func createTimerNotification(focusTime: Int, title: String, subtitle: String, categoryIdentifier: String, inXSeconds: Double) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        // assigning to notification
        content.categoryIdentifier = categoryIdentifier
        
        // trigger and request
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inXSeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: trigger)
        
        // actions
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func createTaskNotification(inXSeconds: Int, title: String, subtitle: String, categoryIdentifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        // assigning to notification
        content.categoryIdentifier = categoryIdentifier
        
        // trigger and request
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(inXSeconds), repeats: false)
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: trigger)
        
        // actions
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
//    func requestAuthorization() {
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
//            if let error = error {
//                print("ERROR \(error)")
//            } else {
//                print("NOTIFICATION PERMISSION SUCCESS")
//            }
//        }
//    }
//
//    func scheduleNotification(title: String, subtitle: String, inXSeconds: Double) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.subtitle = subtitle
//        content.sound = .default
//        content.badge = 1
//
//        // time trigger
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inXSeconds, repeats: false)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString,
//                                            content: content,
//                                            trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request)
//        print("Added notification request")
//    }
}
