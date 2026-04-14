//
//  ImageCropperView.swift
//  MediaGallery
//
//  Created by Mac Mini on 07/04/2026.
//
import SwiftUI
import UIKit
import Mantis

struct ImageCropperView: UIViewControllerRepresentable {
    let image: UIImage
    let onCropped: (UIImage) -> Void
    let onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCropped: onCropped, onCancel: onCancel)
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = context.coordinator

        let navigationController = UINavigationController(rootViewController: cropViewController)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    final class Coordinator: NSObject, CropViewControllerDelegate {
        let onCropped: (UIImage) -> Void
        let onCancel: () -> Void

        init(
            onCropped: @escaping (UIImage) -> Void,
            onCancel: @escaping () -> Void
        ) {
            self.onCropped = onCropped
            self.onCancel = onCancel
        }

        func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            onCancel()
        }

        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            onCancel()
        }

        func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
        }

        func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
        }

        func cropViewControllerDidCrop(
            _ cropViewController: Mantis.CropViewController,
            cropped: UIImage,
            transformation: Transformation,
            cropInfo: CropInfo
        ) {
            onCropped(cropped)
        }
    }
}
