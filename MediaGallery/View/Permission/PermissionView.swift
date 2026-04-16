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
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 54, weight: .regular))
                .foregroundStyle(AppColors.primary)

            Text("Allow Access")
                .font(.title2.weight(.bold))

            Text("We need access to your Photos and Camera to import, capture, crop, and save images in your gallery.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            VStack(spacing: 12) {
                Button {
                    Task {
                        let granted = await viewModel.requestPhotos()
                        if granted { router.replace(with: .gallery) }
                    }
                } label: {
                    Text("Allow Photo Library")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.primary)

                Button {
                    Task {
                        let granted = await viewModel.requestCamera()
                        if granted { router.replace(with: .gallery) }
                    }
                } label: {
                    Text("Allow Camera")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()

            Text("If you denied access, you can enable it later in Settings.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 18)
        }
        .background(AppColors.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .alert("Permission Denied", isPresented: $viewModel.showDeniedAlert) {
            Button("Settings") { viewModel.openSettings() }
            Button("Cancel", role: .cancel) { }
        } message: {
            switch viewModel.deniedType {
            case .camera:
                Text("Camera access is denied. Please enable Camera access in Settings.")
            case .photos:
                Text("Photo Library access is denied. Please enable Photos access in Settings.")
            }
        }
    }
}
