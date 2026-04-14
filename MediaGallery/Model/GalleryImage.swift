//
//  GalleryImage.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation
import SwiftData

@Model
final class GalleryImage {
    var id: UUID
    var imageData: Data
    var createdAt: Date

    init(
        id: UUID = UUID(),
        imageData: Data,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.imageData = imageData
        self.createdAt = createdAt
    }
}
