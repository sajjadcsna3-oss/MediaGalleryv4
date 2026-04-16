//
//  ImageResizeService.swift
//  MediaGalleryv4
//
//  Created by Mac Mini on 16/04/2026.
//
import UIKit

final class ImageResizeService {
    enum Preset: String, CaseIterable, Identifiable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"

        var id: String { rawValue }

        var maxDimension: CGFloat {
            switch self {
            case .small: return 800
            case .medium: return 1200
            case .large: return 2000
            }
        }
    }

    func resize(_ image: UIImage, preset: Preset) -> UIImage {
        image.resized(maxDimension: preset.maxDimension)
    }
}
