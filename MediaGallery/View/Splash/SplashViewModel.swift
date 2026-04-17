//
//  SplashViewModel.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import Combine
@MainActor
final class SplashViewModel: ObservableObject {
    private let permissionService = PermissionService()

    func nextRoute() -> AppRoute {
        let cameraAllowed = permissionService.isCameraAuthorized()
        let photoAllowed = permissionService.isPhotoAuthorized()

        if cameraAllowed || photoAllowed {
            return .gallery
        } else {
            return .permission
        }
    }
}
