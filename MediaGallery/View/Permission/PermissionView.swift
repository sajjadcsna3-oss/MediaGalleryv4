//
//  PermissionView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import SwiftUI

struct PermissionView: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = PermissionViewModel()

    var body: some View {
        ZStack {
            AppColors.screenBackground
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 0) {
                    Text("Welcome to Photo Gallery")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(.top, 44)

                    HStack(spacing: 18) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(width: 74, height: 74)
                                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                            Image(systemName: "camera.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(Color(red: 53/255, green: 61/255, blue: 80/255))
                        }

                        Image(systemName: "play.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.gray.opacity(0.7))

                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(width: 74, height: 74)
                                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)

                            Image(systemName: "photo.on.rectangle.angled.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.pink, .orange, .yellow, .green, .blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    }
                    .padding(.top, 26)

                    Text("This app needs access to your\nCamera and Photo Library to import\nand take photos.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(AppColors.textPrimary.opacity(0.92))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(7)
                        .padding(.top, 28)
                        .padding(.horizontal, 30)

                    VStack(spacing: 10) {
                        Button {
                            Task {
                                let granted = await viewModel.requestCameraOnly()
                                if granted {
                                    router.replace(with: .gallery)
                                } else {
                                    viewModel.showDeniedAlert = true
                                }
                            }
                        } label: {
                            permissionButton(title: "Allow Access to Camera")
                        }

                        Button {
                            Task {
                                let granted = await viewModel.requestPhotosOnly()
                                if granted {
                                    router.replace(with: .gallery)
                                } else {
                                    viewModel.showDeniedAlert = true
                                }
                            }
                        } label: {
                            permissionButton(title: "Allow Access to Photo Library")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    Text("You can enable access in Settings if denied.")
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.top, 18)
                        .padding(.bottom, 24)
                }
                .frame(width: 390)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 34))
                .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden(true)
        .alert("Permission Denied", isPresented: $viewModel.showDeniedAlert) {
            Button("Settings") {
                viewModel.openSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable Camera or Photo Library access in Settings.")
        }
    }

    private func permissionButton(title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
            .frame(width: 300)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
