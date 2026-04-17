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
    enum DeniedType {
        case camera
        case photos
    }

    @Published var showDeniedAlert = false
    @Published var deniedType: DeniedType = .camera

    private let permissionService = PermissionService()

    func requestCamera() async -> Bool {
        let granted = await permissionService.requestCameraAccess()
        if !granted {
            deniedType = .camera
            showDeniedAlert = true
        }
        return granted
    }

    func requestPhotos() async -> Bool {
        let status = await permissionService.requestPhotoAccess()
        let allowed = (status == .authorized || status == .limited)
        if !allowed {
            deniedType = .photos
            showDeniedAlert = true
        }
        return allowed
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
