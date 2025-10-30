//
//  PermissionManager.swift
//  Dating_Side
//
//  Created by 김라영 on 7/21/25.
//

import Photos

/// 사진 관련 유저에게 권한 얻기
final class PermissionManager {
    static let shared = PermissionManager()
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        default:
            completion(false)
        }
    }
}
