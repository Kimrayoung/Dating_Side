//
//  LoadingView.swift
//  Dating_Side
//
//  Created by 김라영 on 7/27/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    
    init(animationName: String, loopMode: LottieLoopMode = .loop, animationSpeed: CGFloat = 1.0) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
    }
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: animationName)
        view.loopMode = loopMode
        view.animationSpeed = animationSpeed
        view.backgroundColor = .clear
        view.play()
        return view
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        if !uiView.isAnimationPlaying {
            uiView.play()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        LottieView(animationName: "loading_new", loopMode: .loop, animationSpeed: 1)
            .frame(width: 150, height: 150)
    }
}

#Preview {
    LoadingView()
}
