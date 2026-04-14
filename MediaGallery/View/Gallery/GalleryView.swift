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

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        ZStack {
            AppColors.screenBackground
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 0) {
                    headerView

                    Divider()
                        .overlay(Color.gray.opacity(0.2))

                    if images.isEmpty {
                        emptyGridPlaceholder

                        Text("No images yet. Import or take photos to start.")
                            .font(.system(size: 12))
                            .foregroundStyle(AppColors.textPrimary.opacity(0.85))
                            .padding(.top, 14)
                            .padding(.bottom, 18)
                    } else {
                        gridView
                    }

                    buttonsRow
                        .padding(.top, 14)
                        .padding(.bottom, 18)
                }
                .frame(width: 305)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
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
        .alert("Photo Access Needed", isPresented: $viewModel.showPhotoPermissionAlert) {
            Button("Settings") {
                viewModel.openSettings()
            }
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please allow photo library access to import photos.")
        }
        .alert("Camera Access Needed", isPresented: $viewModel.showCameraPermissionAlert) {
            Button("Settings") {
                viewModel.openSettings()
            }
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please allow camera access to take photos.")
        }
    }

    private var headerView: some View {
        HStack {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.black)
            }

            Spacer()

            Text("Gallery")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            Spacer()

            Color.clear
                .frame(width: 22, height: 22)
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 12)
    }

    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(images) { item in
                    GalleryGridItemView(imageData: item.imageData)
                        .onTapGesture {
                            router.push(.detail(item.id))
                        }
                }
            }
            .padding(.top, 2)
        }
        .frame(height: 344)
    }

    private var emptyGridPlaceholder: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<10, id: \.self) { _ in
                Rectangle()
                    .fill(Color.gray.opacity(0.08))
                    .frame(height: 82)
            }
        }
        .padding(.top, 2)
        .frame(height: 344)
    }

    private var buttonsRow: some View {
        HStack(spacing: 10) {
            Button {
                viewModel.openPhotoLibrary()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.system(size: 15, weight: .semibold))

                    Text("Import Photo")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(width: 122, height: 36)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 80/255, green: 123/255, blue: 245/255),
                            Color(red: 50/255, green: 97/255, blue: 207/255)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Button {
                viewModel.openCamera()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "camera")
                        .font(.system(size: 15, weight: .semibold))

                    Text("Take Photo")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(width: 122, height: 36)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.primary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
