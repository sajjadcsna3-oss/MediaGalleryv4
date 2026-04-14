//
//  SplashView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = SplashViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 62/255, green: 112/255, blue: 236/255),
                    Color(red: 179/255, green: 114/255, blue: 228/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.white.opacity(0.16))
                        .frame(width: 138, height: 138)

                    Image(systemName: "camera.fill")
                        .font(.system(size: 62))
                        .foregroundStyle(.white)
                }

                Text("Media Gallery")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)

                ProgressView()
                    .tint(.white)
                    .padding(.top, 8)

                Spacer()
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            let route = viewModel.nextRoute()
            router.replace(with: route)
        }
    }
}
