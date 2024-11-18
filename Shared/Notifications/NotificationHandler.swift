//
//  NotificationHandler.swift
//  WaterTracker
//
//  Created by Yu Liang on 10/30/24.
//

import UserNotifications
import WatchConnectivity
import WidgetKit
import Foundation
import SwiftUICore

final class CrossOsConnectivity: NSObject, ObservableObject {
    /*
     * Since we are not using a server to communicating between different devices, the WCSession that used to communicate
     * between the iPhone and Apple Watch is the main method we used to sync notification data.
     * And yes, WaterTracker uses local notification instead of remote notification.
     * If WCSession failed to communicate between the phone and watch (such as the watch is in its cellular mode), then
     * the notification of phone and watch would be out of sync.
     * I have no money for a remote server, so local notification (full local mode / full privacy) it is. 🤷‍♂️
     */
    
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
        
#if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
#else
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#endif
        
        // Ignore the reponse handler.
        // And ignore the error handler either.
        // If the companion doesn't reponse, there is nothing we can do. 🤷‍♂️
        // Inconsistent notification it is (because I don't want to buy a remote server just for this app). 🤷‍♂️
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
            // Rerun the registration after the authorization is finished (no matter the permission is granted or not).
            registerLocalNotification()
        }
        
        // Configure the notification's payload.
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: String(localized: "Time to drink water!"), arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: String(localized: "Log your water status in \(AppName)."), arguments: nil)
        content.sound = UNNotificationSound.default
        
        // Deliver the notification after 2 hours of each time the user log its water drinking.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7200, repeats: false) //  2 hours.
        let request = UNNotificationRequest(identifier: "YuLiang.SimpleWaterTracker.DeferredNotification", content: content, trigger: trigger) // Schedule the notification.
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
        /* Empty and not used. */
    }
    
    // This method is called when a message is sent with failable priority
    // and a reply was *not* requested.
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        // Just register the local notification to be in sync with the companion.
        // And that's it.
        LocalNotificationHandler.registerLocalNotification()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            /* FIXME: widgets out of sync with HealthKit data.
             * Try to refresh the widget after receiving the health data update.
             * However, this is not working because iOS/watchOS is not updating
             * its health data when locked.
             * And it takes times to refresh the HealthKit data on device (in system).
             * Directly refresh the widget asking for HealthKit data update in the
             * background does not work for the time being.
             * This is a bug that only Apple can fix.
             */
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
}
