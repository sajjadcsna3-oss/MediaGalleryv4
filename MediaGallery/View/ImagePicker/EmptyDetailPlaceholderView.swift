//
//  EmptyDetailPlaceholderView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import SwiftUI

struct EmptyDetailPlaceholderView: View {
    var body: some View {
        ZStack {
            AppColors.screenBackground
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 0) {
                    Spacer()

                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.orange.opacity(0.55),
                                    Color.blue.opacity(0.35),
                                    Color.green.opacity(0.45)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 250, height: 320)

                    Text("No images yet.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.top, 14)

                    Text("Import or take photos to start.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 3)

                    Spacer()

                    HStack {
                        Spacer()

                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 24))

                        Spacer()

                        Image(systemName: "arrowshape.turn.up.right")
                            .font(.system(size: 24))

                        Spacer()

                        Image(systemName: "checkmark")
                            .font(.system(size: 24))

                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .frame(height: 80)
                    .background(Color.black.opacity(0.08))
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
    }
}
