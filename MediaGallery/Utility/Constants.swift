//
//  Constants.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.


import SwiftUI

enum Constants {
    static let appTitle = "Photo Gallery"
}

enum AppColors {
    static let primary = Color(red: 42/255, green: 67/255, blue: 124/255)
    static let primaryLight = Color(red: 73/255, green: 102/255, blue: 171/255)

    static let screenBackground = Color(red: 243/255, green: 241/255, blue: 247/255)
    static let cardBackground = Color.white

    static let textPrimary = Color(red: 39/255, green: 48/255, blue: 73/255)
    static let textSecondary = Color(red: 92/255, green: 98/255, blue: 118/255)

    static let detailBackgroundTop = Color(red: 28/255, green: 35/255, blue: 50/255)
    static let detailBackgroundBottom = Color(red: 16/255, green: 20/255, blue: 31/255)

    static let divider = Color.black.opacity(0.08)
}

enum AppStrings {
    // MARK: - Common
    static let ok = "OK"
    static let cancel = "Cancel"
    static let settings = "Settings"
    static let save = "Save"
    static let edit = "Edit"
    static let delete = "Delete"

    // MARK: - Gallery
    static let galleryTitle = "Gallery"
    static let noImagesTitle = "No images yet"
    static let noImagesMessage = "Tap + to import or use Camera."

    // MARK: - Alerts (Gallery)
    static let cameraNotAvailableTitle = "Camera Not Available"
    static let cameraNotAvailableMessage = "This device does not support camera."

    static let photoAccessNeededTitle = "Photo Access Needed"
    static let photoAccessNeededMessage = "Please allow photo library access to import photos."

    static let cameraAccessNeededTitle = "Camera Access Needed"
    static let cameraAccessNeededMessage = "Please allow camera access to take photos."

    // MARK: - Permissions Screen
    static let allowAccessTitle = "Allow Access"
    static let allowAccessMessage = "We need access to your Photos and Camera to import, capture, crop, and save images in your gallery."
    static let allowPhotoLibrary = "Allow Photo Library"
    static let allowCamera = "Allow Camera"
    static let deniedHint = "If you denied access, you can enable it later in Settings."

    // MARK: - Detail
    static let deletePhotoTitle = "Delete Photo?"
    static let deletePhotoMessage = "This action cannot be undone."
    // MARK: - Permission Denied Alert
    static let permissionDeniedTitle = "Permission Denied"
    static let cameraDeniedMessage = "Camera access is denied. Please enable Camera access in Settings."
    static let photosDeniedMessage = "Photo Library access is denied. Please enable Photos access in Settings."
}
