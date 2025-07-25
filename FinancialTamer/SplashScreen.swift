//
//  SplashScreen.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 24.07.2025.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    var loopMode: LottieLoopMode = .playOnce
    var completion: (() -> Void)? = nil

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = loopMode
        animationView.play { _ in
            completion?()
        }
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}

struct SplashScreenView: View {
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            LottieView(name: "animation") {
                // После завершения анимации
                withAnimation {
                    isActive = false
                }
            }
            .frame(width: 300, height: 300)
        }
    }
}
