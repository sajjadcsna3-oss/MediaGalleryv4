//
//  GalleryViewModel.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import UIKit
import SwiftData
import Photos
import AVFoundation
import Combine
@MainActor
final class GalleryViewModel: ObservableObject {
    @Published var showPicker = false
    @Published var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    @Published var showCameraUnavailableAlert = false
    @Published var showPhotoPermissionAlert = false
    @Published var showCameraPermissionAlert = false

    @Published var showCropper = false
    @Published var imageForCrop: UIImage?

    private let imagePickerService = ImagePickerService()
    private let saveService = ImageSaveService()
    private let permissionService = PermissionService()

    func openPhotoLibrary() {
        let status = permissionService.photoStatus()

        switch status {
        case .authorized, .limited:
            pickerSourceType = .photoLibrary
            showPicker = true

        case .notDetermined:
            Task {
                let result = await permissionService.requestPhotoAccess()
                if result == .authorized || result == .limited {
                    self.pickerSourceType = .photoLibrary
                    self.showPicker = true
                } else {
                    self.showPhotoPermissionAlert = true
                }
            }

        case .denied, .restricted:
            showPhotoPermissionAlert = true

        @unknown default:
            showPhotoPermissionAlert = true
        }
    }

    func openCamera() {
        guard imagePickerService.isCameraAvailable() else {
            showCameraUnavailableAlert = true
            return
        }

        let status = permissionService.cameraStatus()
        switch status {
        case .authorized:
            pickerSourceType = .camera
            showPicker = true

        case .notDetermined:
            Task {
                let granted = await permissionService.requestCameraAccess()
                if granted {
                    self.pickerSourceType = .camera
                    self.showPicker = true
                } else {
                    self.showCameraPermissionAlert = true
                }
            }

        case .denied, .restricted:
            showCameraPermissionAlert = true

        @unknown default:
            showCameraPermissionAlert = true
        }
    }

    func handlePickedImage(_ image: UIImage) {
        imageForCrop = image
        showCropper = true
    }

    func handleCroppedImage(_ image: UIImage, context: ModelContext) {
        Task {
            await saveService.saveImage(image, context: context)
            self.showCropper = false
            self.imageForCrop = nil
        }
    }

    func cancelCrop() {
        showCropper = false
        imageForCrop = nil
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
