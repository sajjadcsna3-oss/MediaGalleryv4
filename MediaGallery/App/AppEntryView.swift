//
//  AppEntryView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//

import SwiftUI

struct AppEntryView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            SplashView()
                .environmentObject(router)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .gallery:
                        GalleryView()
                            .environmentObject(router)

                    case .permission:
                        PermissionView()
                            .environmentObject(router)

                    case .detail(let imageId):
                        DetailView(imageId: imageId)
                            .environmentObject(router)
                    }
                }
        }
    }
}
