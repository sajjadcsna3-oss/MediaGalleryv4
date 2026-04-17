//
//  ImageFilterService.swift
//  MediaGalleryv4
//
//  Created by Mac Mini on 16/04/2026.
//
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class ImageFilterService {
    private let context = CIContext()

    func apply(_ filter: FilterType, to image: UIImage) -> UIImage {
        guard filter != .original else { return image }
        guard let cgImage = image.cgImage else { return image }

        let ciImage = CIImage(cgImage: cgImage)

        let output: CIImage?
        switch filter {
        case .original:
            output = ciImage
        case .noir:
            let f = CIFilter.photoEffectNoir()
            f.inputImage = ciImage
            output = f.outputImage
        case .chrome:
            let f = CIFilter.photoEffectChrome()
            f.inputImage = ciImage
            output = f.outputImage
        case .instant:
            let f = CIFilter.photoEffectInstant()
            f.inputImage = ciImage
            output = f.outputImage
        case .sepia:
            let f = CIFilter.sepiaTone()
            f.inputImage = ciImage
            f.intensity = 0.9
            output = f.outputImage
        }

        guard let out = output,
              let outCG = context.createCGImage(out, from: out.extent) else {
            return image
        }

        return UIImage(cgImage: outCG, scale: image.scale, orientation: image.imageOrientation)
    }
}
