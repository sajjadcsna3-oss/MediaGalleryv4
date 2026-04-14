//
//  MediaGalleryv4App.swift
//  MediaGalleryv4
//
//  Created by Mac Mini on 14/04/2026.
//

import SwiftUI
import CoreData

@main
struct MediaGalleryv4App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
