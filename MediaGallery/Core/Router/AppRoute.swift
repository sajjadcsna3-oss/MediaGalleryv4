//
//  AppRoute.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import Foundation

enum AppRoute: Hashable {
    case gallery
    case permission
    case detail(UUID)
}
enum FilterType: String, CaseIterable, Identifiable {
    case original = "Original"
    case noir = "Noir"
    case chrome = "Chrome"
    case instant = "Instant"
    case sepia = "Sepia"

    var id: String { rawValue }
}
