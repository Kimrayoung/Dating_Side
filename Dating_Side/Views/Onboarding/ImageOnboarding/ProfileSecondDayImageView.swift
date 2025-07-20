//
//  ChatProfileAddImageVie.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/19.
//

import SwiftUI
import PhotosUI

struct ProfileSecondImageView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: OnboardingViewModel
    @State var secondDayImageComplete: Bool = false
    @State var selectedPickerImage: [PhotosPickerItem] = []
    @State var isImagePickerPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 14, total: onboardingPageCnt)
                .padding(.top, 30)
                .padding(.bottom, 48)
            TextWithColoredSubString(
                text: "매칭된 상대에게 2일차에 공개할 사진을 등록해주세요",
                highlight: "2일차",
                gradientColors: [.mainColor]
            )
            .font(.pixel(24))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(Color.blackColor)
            Text("흥미있는 대화를 위한 사진입니다.\n2일차에 보여주고 싶은 나의 모습을 등록해주세요")
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(Color.gray3)
                .padding(.bottom, 36)
            ZStack {
                sixthDayImage
                forthDayImage
                secondDayImage
            }
            .padding(.bottom, 70)
            Button(action: {
                if viewModel.selectedSeconDayImage == nil {
                    return
                }
                appState.onboardingPath.append(Onboarding.forthDayPhoto)
            }, label: {
                SelectButtonLabel(isSelected: $secondDayImageComplete, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .onAppear {
            if viewModel.selectedSeconDayImage != nil {
                secondDayImageComplete = true
            }
        }
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
    
    var secondDayImage: some View {
        Button {
            isImagePickerPresented = true
        } label: {
            if let image = viewModel.selectedSeconDayImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 9.57))
            } else {
                Image("checkerImage")
                    .frame(width: 240, height: 360)
            }
        }
        .photosPicker(
            isPresented: $isImagePickerPresented,
            selection: $selectedPickerImage,
            maxSelectionCount: 1,
            matching: .images
        )
        .onChange(of: selectedPickerImage, {
            guard let selectedPickerImage = selectedPickerImage.first else { return }
            viewModel.loadSelectedImage(imageType: .secondDay, pickerItem: selectedPickerImage)
        })
        
        .onChange(of: viewModel.selectedSeconDayImage) {
            if viewModel.selectedSeconDayImage != nil {
                secondDayImageComplete = true
            }
        }
        
    }
    
    var forthDayImage: some View {
        RoundedRectangle(cornerRadius: 9.57)
            .fill(Color.subColor)
            .frame(width: 240, height: 360)
            .padding(.leading, 16)
    }
    
    var sixthDayImage: some View {
        RoundedRectangle(cornerRadius: 9.57)
            .fill(Color.subColor1)
            .frame(width: 240, height: 360)
            .padding(.leading, 30)
    }
}

#Preview {
    ProfileSecondImageView(viewModel: OnboardingViewModel())
}
