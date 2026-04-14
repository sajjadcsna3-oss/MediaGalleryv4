//
//  ActivityViewController.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import SwiftUI
import UIKit

struct ActivityViewController: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
    }
    

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
