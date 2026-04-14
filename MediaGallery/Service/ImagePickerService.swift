//
//  ImagePickerService.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import UIKit

final class ImagePickerService {

    func isCameraAvailable() -> Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    func sourceType(forCamera useCamera: Bool) -> UIImagePickerController.SourceType {
        if useCamera, UIImagePickerController.isSourceTypeAvailable(.camera) {
            return .camera
        } else {
            return .photoLibrary
        }
    }
}
