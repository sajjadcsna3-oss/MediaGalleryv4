//
//  ImageSaveService.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import UIKit
import SwiftData

final class ImageSaveService {

    func saveImage(_ image: UIImage, context: ModelContext) async {
        await Task.detached {
            let resizedImage = image.resized(maxDimension: 1200)

            guard let data = resizedImage.jpegData(compressionQuality: 0.8) else {
                return
            }

            let item = GalleryImage(imageData: data)

            await MainActor.run {
                context.insert(item)
                try? context.save()
            }
        }.value
    }

    func updateImage(_ item: GalleryImage, with image: UIImage, context: ModelContext) async {
        await Task.detached {
            let resizedImage = image.resized(maxDimension: 1200)

            guard let data = resizedImage.jpegData(compressionQuality: 0.8) else {
                return
            }

            await MainActor.run {
                item.imageData = data
                try? context.save()
            }
        }.value
    }
}
