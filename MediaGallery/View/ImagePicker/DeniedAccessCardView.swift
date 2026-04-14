//
//  DeniedAccessCardView.swift
//  MediaGallery
//
//  Created by Mac Mini on 06/04/2026.
//
import SwiftUI

struct DeniedAccessCardView: View {
    let openSettings: () -> Void

    var body: some View {
        ZStack {
            AppColors.screenBackground
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 0) {
                    Text("Access Denied")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(.top, 28)

                    Divider()
                        .padding(.top, 20)
                        .padding(.horizontal, 22)

                    Text("To enable photo access, go to:")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(.top, 26)

                    Text("Settings > Privacy > Photos / Camera")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 22)
                        .padding(.horizontal, 20)

                    Button(action: openSettings) {
                        Text("Open Settings")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 186, height: 50)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primaryLight, AppColors.primary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 30)

                    Divider()
                        .padding(.top, 26)
                        .padding(.horizontal, 22)

                    Text("Follow the instructions above to enable access.")
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 18)
                        .padding(.bottom, 24)
                        .padding(.horizontal, 16)
                }
                .frame(width: 330)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 34))
                .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)

                Spacer()
            }
        }
    }
}
