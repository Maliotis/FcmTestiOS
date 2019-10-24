//
//  FirebaseAppDelegate.swift
//  FCMTest
//
//  Created by petros maliotis on 24/10/2019.
//  Copyright © 2019 petros maliotis. All rights reserved.
//

import UserNotifications
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message ID: \(messageID)")
//        }

        
        let aps = userInfo["aps"] as? [String : Any]
        let alert = aps?["alert"] as? [String : Any]
        let body = alert?["body"] as? String
        let title = alert?["title"] as? String
        
        print("aps == \(String(describing: aps))")
        print("alert == \(String(describing: alert))")
        print("title == \(String(describing: title))")
        print("body == \(String(describing: body))")
        // Print full message.
        print(userInfo)
        
        let content = UNMutableNotificationContent()
        content.title = title!
        content.body = body!
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    
        //print("Message ID: \(userInfo.)")

        // Print full message.
        //print("FCM notification: \(userInfo)")
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    // Register for push notifications
    func registerForPushNotification(){
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}


extension AppDelegate: MessagingDelegate {
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

        print("##  Fcm Token == \(fcmToken)   ##")
        
        let dataDict:[String: String] = ["token": fcmToken]
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            //self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            //send token to server
          }
        }
        
    }
}
