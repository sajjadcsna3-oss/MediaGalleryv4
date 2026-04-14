//
//  UIImage+Resize.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import UIKit

extension UIImage {
    func resized(maxDimension: CGFloat = 1200) -> UIImage {
        let originalSize = size
        let maxSide = max(originalSize.width, originalSize.height)

        guard maxSide > maxDimension else {
            return self
        }

        let scale = maxDimension / maxSide
        let newSize = CGSize(
            width: originalSize.width * scale,
            height: originalSize.height * scale
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
