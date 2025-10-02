//
//  PushNotificationManager.swift
//  Dating_Side
//
//  Created by 김라영 on 10/2/25.
//

import Foundation

import UIKit
import UserNotifications

@MainActor
final class PushNotificationManager: ObservableObject {
    private let center = UNUserNotificationCenter.current()
    
    /// 상태 새로고침 (UI 바인딩용)
    func refresh() {
        center.getNotificationSettings { [weak self] s in
            guard let self = self else { return }
            let enabled = Self.isUsable(settings: s)
            // 현 상태와 다를 때만 저장
            if UserDefaults.standard.bool(forKey: "PushNoticiationEnabled") != enabled {
                UserDefaults.standard.set(enabled, forKey: "PushNoticiationEnabled")
            }
        }
    }

    /// 처음 권한 요청 (미결정일 때 사용)
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                // 원격 푸시 사용 시 권장
                await MainActor.run { UIApplication.shared.registerForRemoteNotifications() }
            }
            await MainActor.run { self.refresh() }
            return granted
        } catch {
            await MainActor.run { self.refresh() }
            return false
        }
    }

    /// 설정 앱의 “이 앱 알림” 화면으로 이동 (가능 시 바로 알림 탭)
    func openNotificationSettings() {
        if let url = URL(string: UIApplication.openNotificationSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return
        }
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    /// 현재 시스템 알림 설정 객체 가져오기 (세부 판단이 필요할 때)
    func currentSettings() async -> UNNotificationSettings {
        await withCheckedContinuation { cont in
            center.getNotificationSettings { s in cont.resume(returning: s) }
        }
    }

    // PushNotification이 사용가능한 상태인지 상태 매핑
    private static func isUsable(settings s: UNNotificationSettings) -> Bool {
        let authOK: Bool = {
            switch s.authorizationStatus {
            case .authorized, .provisional, .ephemeral: return true
            default: return false
            }
        }()
        let anyChannelOn = [s.alertSetting, s.soundSetting, s.badgeSetting].contains(.enabled)
        return authOK && anyChannelOn
    }
}

