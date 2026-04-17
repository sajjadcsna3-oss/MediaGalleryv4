//
//  DetailViewModel.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
//
//  DetailViewModel.swift
//  MediaGallery
//

import Foundation
import UIKit
import SwiftData
import Combine
@MainActor
final class DetailViewModel: ObservableObject {
   
    @Published var showShareSheet = false
    @Published var shareImage: UIImage?

    // Picker (optional usage)
    @Published var showPicker = false
    @Published var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showCameraUnavailableAlert = false

    // Crop
    @Published var showCropper = false
    @Published var imageForCrop: UIImage?

    // Editing State
    @Published var isEditing = false

    // Working image (edited but not saved yet)
    @Published var newImage: UIImage?

    // Filter UI state
    @Published var selectedFilter: FilterType = .original

    // Resize UI state
    @Published var selectedResize: ImageResizeService.Preset = .medium

    private let saveService = ImageSaveService()
    private let imagePickerService = ImagePickerService()
    private let cropService = ImageCropService()
    private let filterService = ImageFilterService()
    private let resizeService = ImageResizeService()

    // MARK: - Share
    func share(image: UIImage) {
        shareImage = image
        showShareSheet = true
    }

    // MARK: - Edit mode
    func toggleEditMode(currentImage: UIImage) {
        if isEditing {
           
            return
        } else {
            // enter edit mode
            isEditing = true
            // initialize working image if not set
            if newImage == nil {
                newImage = currentImage
            }
            selectedFilter = .original
            selectedResize = .medium
        }
    }

    func cancelEditing() {
        isEditing = false
        selectedFilter = .original
      
        newImage = nil
    }

    // MARK: - Crop
    func startCropCurrentImage(_ image: UIImage) {
        imageForCrop = cropService.prepareImageForCrop(image)
        showCropper = true
    }

    func handleCroppedImage(_ image: UIImage) {
        newImage = image
        showCropper = false
        imageForCrop = nil
    }

    func cancelCrop() {
        showCropper = false
        imageForCrop = nil
    }

    // MARK: - Filters
    func applySelectedFilter(on base: UIImage) {
        let filtered = filterService.apply(selectedFilter, to: base)
        newImage = filtered
    }

    // MARK: - Resize
    func applyResize(on base: UIImage) {
        let resized = resizeService.resize(base, preset: selectedResize)
        newImage = resized
    }

    // MARK: - Save / Update
    func saveEditsIfNeeded(item: GalleryImage, context: ModelContext) {
        guard let newImage else {
            isEditing = false
            return
        }

        Task {
            await saveService.updateImage(item, with: newImage, context: context)
            self.isEditing = false
            self.newImage = nil
            self.selectedFilter = .original
        }
    }

    // MARK: - Delete
    func delete(item: GalleryImage, context: ModelContext) {
        context.delete(item)
        try? context.save()
    }

    // MARK: - Camera availability (if you want update via camera/library in detail later)
    func openCameraForUpdate() {
        if imagePickerService.isCameraAvailable() {
            pickerSourceType = .camera
            showPicker = true
        } else {
            showCameraUnavailableAlert = true
        }
    }

    func openLibraryForUpdate() {
        pickerSourceType = .photoLibrary
        showPicker = true
    }

    func handlePickedImage(_ image: UIImage) {
        showPicker = false
        let prepared = cropService.prepareImageForCrop(image)
        imageForCrop = prepared

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(150))
            self.showCropper = true
        }
    }
}
