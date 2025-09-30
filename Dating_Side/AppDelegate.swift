//
//  AppDelegate.swift
//  Dating_Side
//
//  Created by 김라영 on 7/14/25.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        // Method swizzling 비활성화했으므로 수동 설정 필요
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            print("푸시 알림 권한: \(granted)")
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // APNS 토큰을 FCM에 전달 (수동 처리)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNS 등록 실패: \(error)")
    }
    
    // 백그라운드에서 푸시 알림 수신 (수동 처리)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "없음")")
        if let originalToken = UserDefaults.standard.string(forKey: "FCMToken") {
            print("저장된 FCM Token: \(originalToken)")
            if originalToken != fcmToken {
                UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
                UserDefaults.standard.set(true, forKey: "NeedTokenChange")
            }
        } else {
            print("저장된 토큰이 없습니다.")
        }
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Firebase Analytics 이벤트 전송 (수동 처리)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Firebase Analytics 이벤트 전송 (수동 처리)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler()
    }
}
