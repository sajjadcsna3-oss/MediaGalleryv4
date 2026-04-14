//
//  ImageShareService.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import UIKit

final class ImageShareService {

    func makeShareController(image: UIImage) -> UIActivityViewController {
        UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }
}
