//
//  GalleryGridItemView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
import SwiftUI

struct GalleryGridItemView: View {
    let imageData: Data

    var body: some View {
        ZStack {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.15))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
