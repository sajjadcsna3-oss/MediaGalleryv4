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

            Text(AppStrings.allowAccessTitle)
                .font(.title2.weight(.bold))

            Text(AppStrings.allowAccessMessage)
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
                    Text(AppStrings.allowPhotoLibrary)
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
                    Text(AppStrings.allowCamera)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()

            Text(AppStrings.deniedHint)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 18)
        }
        .background(AppColors.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .alert(AppStrings.permissionDeniedTitle, isPresented: $viewModel.showDeniedAlert) {
            Button(AppStrings.settings) { viewModel.openSettings() }
            Button(AppStrings.cancel, role: .cancel) { }
        } message: {
            switch viewModel.deniedType {
            case .camera:
                Text(AppStrings.cameraDeniedMessage)
            case .photos:
                Text(AppStrings.photosDeniedMessage)
            }
        
        }
    }
}
