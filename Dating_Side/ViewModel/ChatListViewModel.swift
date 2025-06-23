//
//  ChatListViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/06/23.
//

import Foundation

class ChatListViewModel: ObservableObject {
    @Published var timeString: String = "24:00"
    var timer: Timer?
    var totalSeconds: Int = 24 * 60 * 60
    
    func startTimer() {
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
        totalSeconds = 24 * 60 * 60
        updateTimeString()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        guard totalSeconds > 0 else {
            timer?.invalidate()
            timeString = "00:00"
            return
        }
        
        totalSeconds -= 1
        updateTimeString()
    }
    
    private func updateTimeString() {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        timeString = String(format: "%02d:%02d", hours, minutes)
    }
}
