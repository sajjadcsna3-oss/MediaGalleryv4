//
//  DetailViewModel.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import UIKit
import SwiftData
import Combine
@MainActor
final class DetailViewModel: ObservableObject {
    @Published var showShareSheet = false
    @Published var shareImage: UIImage?

    @Published var showPicker = false
    @Published var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var pickedImage: UIImage?

    @Published var showCameraUnavailableAlert = false

    @Published var showCropper = false
    @Published var imageForCrop: UIImage?

    @Published var newImage: UIImage?   // pending image to save

    private let saveService = ImageSaveService()
    private let imagePickerService = ImagePickerService()
    private let cropService = ImageCropService()

    func share(image: UIImage) {
        shareImage = image
        showShareSheet = true
    }

    // If you still want "replace from library" flow (optional)
    func openLibraryForUpdate() {
        pickerSourceType = .photoLibrary
        showPicker = true
    }

    func openCameraForUpdate() {
        if imagePickerService.isCameraAvailable() {
            pickerSourceType = .camera
            showPicker = true
        } else {
            showCameraUnavailableAlert = true
        }
    }

    func handlePickedImage(_ image: UIImage) {
        pickedImage = image
        imageForCrop = cropService.prepareImageForCrop(image)
        showCropper = true
    }

    func startCropCurrentImage(_ image: UIImage) {
        imageForCrop = cropService.prepareImageForCrop(image)
        showCropper = true
    }

    func handleCroppedImage(_ image: UIImage) {
        // do not save immediately; wait for Save button
        newImage = image
        showCropper = false
        imageForCrop = nil
        pickedImage = nil
    }

    func cancelCrop() {
        showCropper = false
        imageForCrop = nil
        pickedImage = nil
    }

    func updateImageIfNeeded(item: GalleryImage, context: ModelContext) {
        guard let newImage else { return }

        Task {
            await saveService.updateImage(item, with: newImage, context: context)
            self.newImage = nil
        }
    }
}
