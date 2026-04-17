//
//  PermissionService.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import Photos
import AVFoundation

final class PermissionService {

    func cameraStatus() -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    func photoStatus() -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    func isCameraAuthorized() -> Bool {
        let status = cameraStatus()
        return status == .authorized
    }

    func isPhotoAuthorized() -> Bool {
        let status = photoStatus()
        return status == .authorized || status == .limited
    }

    func requestCameraAccess() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }

    func requestPhotoAccess() async -> PHAuthorizationStatus {
        await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
}
