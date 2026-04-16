//
//  GalleryView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.


import SwiftUI
import SwiftData

struct DetailView: View {
    let imageId: UUID

    @EnvironmentObject private var router: AppRouter
    @Environment(\.modelContext) private var context
    @Query private var images: [GalleryImage]

    @StateObject private var viewModel = DetailViewModel()

    @State private var showDeleteConfirm = false

    private var selectedItem: GalleryImage? {
        images.first(where: { $0.id == imageId })
    }

    private var selectedUIImage: UIImage? {
        guard let data = selectedItem?.imageData else { return nil }
        return UIImage(data: data)
    }

    private var displayImage: UIImage? {
        viewModel.newImage ?? selectedUIImage
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let item = selectedItem, let image = displayImage {
                viewer(item: item, image: image)
            } else {
                Text("Image not found")
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .confirmationDialog(
            "Delete Photo?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let item = selectedItem {
                    viewModel.delete(item: item, context: context)
                    router.pop() // close detail
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let img = viewModel.shareImage {
                ActivityViewController(image: img)
            }
        }
        .sheet(isPresented: $viewModel.showCropper) {
            if let cropImage = viewModel.imageForCrop {
                ImageCropperView(
                    image: cropImage,
                    onCropped: { cropped in
                        viewModel.handleCroppedImage(cropped)
                    },
                    onCancel: {
                        viewModel.cancelCrop()
                    }
                )
            }
        }
    }

    private func viewer(item: GalleryImage, image: UIImage) -> some View {
        VStack(spacing: 0) {
            topBar(item: item, currentImage: image)

            Spacer(minLength: 0)

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)

            Spacer(minLength: 0)

            if viewModel.isEditing {
                editToolsBar(item: item, currentImage: image)
            } else {
                normalBottomBar(currentImage: image)
            }
        }
    }

    private func topBar(item: GalleryImage, currentImage: UIImage) -> some View {
        HStack {
            Button {
                // If editing, cancel edits on back (Photos-like)
                if viewModel.isEditing {
                    viewModel.cancelEditing()
                }
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.black.opacity(0.35))
                    .clipShape(Circle())
            }

            Spacer()

            // Delete always visible (as per requirement)
            Button {
                showDeleteConfirm = true
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.black.opacity(0.35))
                    .clipShape(Circle())
            }

            // Edit / Save toggle button
            if viewModel.isEditing {
                Button {
                    viewModel.saveEditsIfNeeded(item: item, context: context)
                } label: {
                    Text("Save")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(.blue.opacity(0.95))
                        .clipShape(Capsule())
                }
            } else {
                Button {
                    viewModel.toggleEditMode(currentImage: currentImage)
                } label: {
                    Text("Edit")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(.black.opacity(0.35))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
    }

    private func normalBottomBar(currentImage: UIImage) -> some View {
        HStack {
            Button {
                viewModel.share(image: currentImage)
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            // Optional: quick crop even without edit mode (آپ چاہیں تو remove کر دیں)
            Button {
                viewModel.startCropCurrentImage(currentImage)
            } label: {
                Image(systemName: "crop")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 16)
        .background(.black.opacity(0.6))
    }

    private func editToolsBar(item: GalleryImage, currentImage: UIImage) -> some View {
        VStack(spacing: 10) {
            // Tools row: Crop / Resize apply
            HStack(spacing: 18) {
                Button {
                    viewModel.startCropCurrentImage(currentImage)
                } label: {
                    toolPill(title: "Crop", systemName: "crop")
                }

                Menu {
                    ForEach(ImageResizeService.Preset.allCases) { preset in
                        Button(preset.rawValue) {
                            viewModel.selectedResize = preset
                            viewModel.applyResize(on: currentImage)
                        }
                    }
                } label: {
                    toolPill(title: "Resize", systemName: "arrow.up.left.and.arrow.down.right")
                }
            }
            .padding(.top, 6)

            // Filters horizontal strip
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(FilterType.allCases) { filter in
                        Button {
                            viewModel.selectedFilter = filter
                            viewModel.applySelectedFilter(on: currentImage)
                        } label: {
                            Text(filter.rawValue)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(filter == viewModel.selectedFilter ? .black : .white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(filter == viewModel.selectedFilter ? .white : .white.opacity(0.18))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            }

            // Bottom actions
            HStack {
                Button {
                    viewModel.cancelEditing()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.16))
                        .clipShape(Capsule())
                }

                Spacer()

                Button {
                    viewModel.share(image: currentImage)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 8)
        }
        .background(.black.opacity(0.75))
    }

    private func toolPill(title: String, systemName: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemName)
            Text(title)
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.white.opacity(0.18))
        .clipShape(Capsule())
    }
}
