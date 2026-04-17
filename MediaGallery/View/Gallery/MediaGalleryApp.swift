//
//  MediaGalleryApp.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//

import SwiftUI
import SwiftData

@main
struct MediaGalleryAppApp: App {
    var body: some Scene {
        WindowGroup {
            AppEntryView()
        }
        .modelContainer(for: GalleryImage.self)
    }
}
