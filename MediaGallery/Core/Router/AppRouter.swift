//
//  Router.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import SwiftUI
import Combine
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func replace(with route: AppRoute) {
        path = NavigationPath()
        path.append(route)
    }
}
