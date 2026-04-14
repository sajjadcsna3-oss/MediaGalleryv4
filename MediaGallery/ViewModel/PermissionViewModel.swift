//
//  PermissionViewModel.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import UIKit
import Photos
import Combine
@MainActor
final class PermissionViewModel: ObservableObject {
    @Published var showDeniedAlert = false

    private let permissionService = PermissionService()

    func requestCameraOnly() async -> Bool {
        let granted = await permissionService.requestCameraAccess()
        return granted
    }

    func requestPhotosOnly() async -> Bool {
        let status = await permissionService.requestPhotoAccess()
        return status == .authorized || status == .limited
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
