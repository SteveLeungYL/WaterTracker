//
//  NotificationHandler.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import UserNotifications
import WatchConnectivity
import WidgetKit
import Foundation

final class CrossOsConnectivity: NSObject, ObservableObject {
    
    // Is published necessary?
    @Published var receivedInfo: String = ""
    
    // For communicating between watchOS and iOS
    static let shared = CrossOsConnectivity()
    
    private override init() {
        super.init()
        
#if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
#endif
        WCSession.default.delegate = self
        WCSession.default.activate()
        
    }
    
    public func sendNotificationReminder() {
        
        guard WCSession.default.activationState == .activated else {
            return
        }
        
        // 1
#if os(watchOS)
        // 2
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
#else
        // 3
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#endif
        
        // Ignore the reponse handler.
        // And ignore the error handler either.
        // If the companion doesn't reponse, we cannot do anything. 🤷🏻
        // Inconsistent notification it is. 🤷🏻
        WCSession.default.sendMessage(["msg": "Send Reminder"], replyHandler: nil)
    }
}

public final class LocalNotificationHandler {
    
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
        
        Task {
            await LocalNotificationHandler.askForNotificationAuthorization()
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

// MARK: - WCSessionDelegate
extension CrossOsConnectivity: WCSessionDelegate {
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
#endif
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
    }
    
    // This method is called when a message is sent with failable priority
    // and a reply was *not* requested.
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        // Just register the information.
        // And that's it.
        LocalNotificationHandler.registerLocalNotification()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}
