//
//  GalleryView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//

import SwiftUI
import SwiftData

struct GalleryView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.modelContext) private var context
    @Query(sort: \GalleryImage.createdAt, order: .reverse) private var images: [GalleryImage]

    @StateObject private var viewModel = GalleryViewModel()

    private let columnsCount: Int = 3
    private let spacing: CGFloat = 1
    private let outerPadding: CGFloat = 1

    var body: some View {
        GeometryReader { geo in
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let totalOuter = outerPadding * 2
            let side = floor((geo.size.width - totalSpacing - totalOuter) / CGFloat(columnsCount))

            ScrollView {
                if images.isEmpty {
                    emptyState
                        .frame(maxWidth: .infinity, minHeight: 420)
                } else {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(side), spacing: spacing), count: columnsCount),
                        spacing: spacing
                    ) {
                        ForEach(images) { item in
                            PhotosGridCell(imageData: item.imageData, side: side)
                                .onTapGesture {
                                    router.push(.detail(item.id))
                                }
                        }
                    }
                    .padding(.horizontal, outerPadding)
                    .padding(.top, outerPadding)
                }
            }
            .background(Color.white)
            .navigationTitle("Gallery")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // PLUS button (Import)
                    Button {
                        viewModel.openPhotoLibrary()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.black.opacity(0.85))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Import Photo")

                    // Camera remains
                    Button {
                        viewModel.openCamera()
                    } label: {
                        Image(systemName: "camera")
                    }
                    .accessibilityLabel("Take Photo")
                }
            }
            .sheet(isPresented: $viewModel.showPicker) {
                ImagePickerSheet(sourceType: viewModel.pickerSourceType) { image in
                    viewModel.handlePickedImage(image)
                }
            }
            .sheet(isPresented: $viewModel.showCropper) {
                if let image = viewModel.imageForCrop {
                    ImageCropperView(
                        image: image,
                        onCropped: { croppedImage in
                            viewModel.handleCroppedImage(croppedImage, context: context)
                        },
                        onCancel: { viewModel.cancelCrop() }
                    )
                }
            }
            .alert("Camera Not Available", isPresented: $viewModel.showCameraUnavailableAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("This device does not support camera.")
            }
            .alert("Photo Access Needed", isPresented: $viewModel.showPhotoPermissionAlert) {
                Button("Settings") { viewModel.openSettings() }
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please allow photo library access to import photos.")
            }
            .alert("Camera Access Needed", isPresented: $viewModel.showCameraPermissionAlert) {
                Button("Settings") { viewModel.openSettings() }
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please allow camera access to take photos.")
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Text("No images yet")
                .font(.title3.weight(.semibold))

            Text("Tap + to import or use Camera.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.top, 40)
    }
}
