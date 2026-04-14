//
//  GalleryGridItemView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
import SwiftUI

struct GalleryGridItemView: View {
    let imageData: Data

    var body: some View {
        Group {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 82)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 82)
            }
        }
    }
}
