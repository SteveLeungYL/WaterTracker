//
//  NotificationHandler.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import UserNotifications

public struct NotificationHandler {
    
    static public func askForNotificationAuthorization() async {
        
        let center = UNUserNotificationCenter.current()
        do {
            try await center.requestAuthorization(options: [.sound, .alert])
        } catch {
            // Handle the error here.
            print("Notification Registration Error?")
        }
    }
    
    static public func registerLocalNotification() {
        
        // FIXME:: Should not be here.
        Task {
            await NotificationHandler.askForNotificationAuthorization()
        }

        // Configure the notification's payload.
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time to drink water!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Log your water status in \(AppName).", arguments: nil)
        content.sound = UNNotificationSound.default
         
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7200, repeats: false) //  2 hours.
        let request = UNNotificationRequest(identifier: "SteveLeung.WaterTracer.DeferredNotification", content: content, trigger: trigger) // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
             if let theError = error {
                 print(theError.localizedDescription)
             }
        }
    }
}
