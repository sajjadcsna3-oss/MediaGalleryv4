//
//  PhotosGridCell.swift
//  MediaGalleryv4
//
//  Created by Mac Mini on 16/04/2026.
//
import SwiftUI

struct PhotosGridCell: View {
    let imageData: Data
    let side: CGFloat

    var body: some View {
        ZStack {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: side, height: side)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.12))
                    .frame(width: side, height: side)
            }
        }
        .frame(width: side, height: side)
        .overlay(
            Rectangle().stroke(Color.white, lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
}
