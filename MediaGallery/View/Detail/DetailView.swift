//
//  GalleryView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import SwiftUI
import SwiftData

struct DetailView: View {
    let imageId: UUID

    @EnvironmentObject private var router: AppRouter
    @Environment(\.modelContext) private var context
    @Query private var images: [GalleryImage]

    @StateObject private var viewModel = DetailViewModel()

    private var selectedItem: GalleryImage? {
        images.first(where: { $0.id == imageId })
    }

    private var selectedUIImage: UIImage? {
        guard let data = selectedItem?.imageData else { return nil }
        return UIImage(data: data)
    }

    // If user cropped but not saved yet, show that image on UI
    private var displayImage: UIImage? {
        viewModel.newImage ?? selectedUIImage
    }

    var body: some View {
        ZStack {
            AppColors.screenBackground
                .ignoresSafeArea()

            Group {
                if let item = selectedItem,
                   let image = displayImage {
                    contentView(item: item, image: image)
                } else {
                    Text("Image not found")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $viewModel.showPicker) {
            ImagePickerSheet(sourceType: viewModel.pickerSourceType) { image in
                viewModel.handlePickedImage(image)
            }
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let image = viewModel.shareImage {
                ActivityViewController(image: image)
            }
        }
        .sheet(isPresented: $viewModel.showCropper) {
            if let cropImage = viewModel.imageForCrop {
                ImageCropperView(
                    image: cropImage,
                    onCropped: { croppedImage in
                        viewModel.handleCroppedImage(croppedImage)
                    },
                    onCancel: {
                        viewModel.cancelCrop()
                    }
                )
            }
        }
        .alert("Camera Not Available", isPresented: $viewModel.showCameraUnavailableAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This device does not support camera.")
        }
    }

    private func contentView(item: GalleryImage, image: UIImage) -> some View {
        VStack {
            Spacer()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                Spacer()

                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 340)
                    .clipped()
                    .padding(.top, 10)

                Spacer()

                bottomToolbar(item: item, image: image)
            }
            .frame(width: 300, height: 565)
            .background(
                LinearGradient(
                    colors: [AppColors.detailBackgroundTop, AppColors.detailBackgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 34))
            .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 12)

            Spacer()
        }
    }

    private func bottomToolbar(item: GalleryImage, image: UIImage) -> some View {
        HStack {
            Spacer()

            Button {
                // Crop CURRENT displayed image (original or pending cropped)
                viewModel.startCropCurrentImage(image)
            } label: {
                toolbarItem(icon: "crop", title: "Crop")
            }

            Spacer()

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 1, height: 30)

            Spacer()

            Button {
                viewModel.share(image: image)
            } label: {
                toolbarItem(icon: "arrowshape.turn.up.right.fill", title: "Share")
            }

            Spacer()

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 1, height: 30)

            Spacer()

            Button {
                viewModel.updateImageIfNeeded(item: item, context: context)
            } label: {
                toolbarItem(icon: "square.and.arrow.down.fill", title: "Save")
            }
            .opacity(viewModel.newImage == nil ? 0.55 : 1.0)
            .disabled(viewModel.newImage == nil)

            Spacer()
        }
        .frame(height: 82)
        .background(Color.black.opacity(0.08))
    }

    private func toolbarItem(icon: String, title: String) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(.white)

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}
