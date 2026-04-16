//
//  ImageSaveService.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import UIKit
import SwiftData

@MainActor
final class ImageSaveService {

    func saveImage(_ image: UIImage, context: ModelContext) async {
        // process image off-main, but keep context operations on main actor
        let data: Data? = await Task(priority: .userInitiated) {
            let resized = image.resized(maxDimension: 1200)
            return resized.jpegData(compressionQuality: 0.8)
        }.value

        guard let data else { return }

        let item = GalleryImage(imageData: data)
        context.insert(item)
        try? context.save()
    }

    func updateImage(_ item: GalleryImage, with image: UIImage, context: ModelContext) async {
        let data: Data? = await Task(priority: .userInitiated) {
            let resized = image.resized(maxDimension: 1200)
            return resized.jpegData(compressionQuality: 0.8)
        }.value

        guard let data else { return }

        item.imageData = data
        try? context.save()
    }
}
