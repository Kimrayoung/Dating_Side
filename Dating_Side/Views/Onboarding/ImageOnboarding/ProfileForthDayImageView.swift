//
//  ChatProfileAddImageVie.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/19.
//

import SwiftUI
import PhotosUI

/// 4일차에 상대방에게 보여줄 사진
struct ProfileForthImageView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    @State var forthDayImageComplete: Bool = false
    @State var selectedPickerImage: [PhotosPickerItem] = []
    @State var isImagePickerPresented: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            EmptyView()
                .padding(.top, 30)
            if viewModel.isOnboarding {
                CustomRounedGradientProgressBar(currentProgress: 15, total: onboardingPageCnt)
            }
            TextWithColoredSubString(
                text: "매칭된 상대에게 4일차에 공개할 사진을 등록해주세요",
                highlight: "4일차",
                gradientColors: [.mainColor]
            )
            .font(.pixel(24))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 48)
            .foregroundStyle(Color.blackColor)
            Text("흥미있는 대화를 위한 사진입니다.\n4일차에 보여주고 싶은 나의 모습을 등록해주세요")
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(Color.gray3)
                .padding(.bottom, 36)
            ZStack {
                sixthDayImage
                forthDayImage
            }
            .padding(.bottom, 70)
            Button(action: {
                if viewModel.selectedForthDayImage == nil {
                    return
                }
                appState.onboardingPath.append(Onboarding.sixthDayPhoto)
            }, label: {
                SelectButtonLabel(isSelected: $forthDayImageComplete, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .onAppear {
            if viewModel.selectedForthDayImage != nil {
               forthDayImageComplete = true
            }
        }
        .customAlert(isPresented: $showAlert, title: "오류", message: "설정에서 접근 권한을 허용해주세요", primaryButtonText: "취소", primaryButtonAction: {}, secondaryButtonText: "설정으로 이동", secondaryButtonAction: {})
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.onboardingPath.removeLast()
                } label: {
                    Image("navigationBackBtn")
                }
            }
        })
    }
    
    var forthDayImage: some View {
        PhotoPickerButton(
            imageType: .forthDay,
            isPresented: $isImagePickerPresented,
            selectedPickerImage: $selectedPickerImage,
            showAlert: $showAlert,
            onImagePicked: { item in
                viewModel.loadSelectedImage(imageType: .forthDay, pickerItem: item)
            }) {
                Group {
                    if let image = viewModel.selectedForthDayImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 240, height: 360)
                            .clipShape(RoundedRectangle(cornerRadius: 9.57))
                    } else {
                        RoundedRectangle(cornerRadius: 9.57)
                            .fill(Color.subColor)
                            .frame(width: 240, height: 360)
                    }
                }
            }
            .onChange(of: viewModel.selectedForthDayImage) {
                if viewModel.selectedForthDayImage != nil {
                    forthDayImageComplete = true
                }
            }
    }
    
    var sixthDayImage: some View {
        RoundedRectangle(cornerRadius: 9.57)
            .fill(Color.subColor1)
            .frame(width: 240, height: 360)
            .padding(.leading, 16)
    }
}

#Preview {
    ProfileForthImageView(viewModel: AccountViewModel())
}
