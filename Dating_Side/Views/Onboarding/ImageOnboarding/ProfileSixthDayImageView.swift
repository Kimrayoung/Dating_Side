//
//  ChatProfileAddImageVie.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/19.
//

import SwiftUI
import PhotosUI

struct ProfileSixthImageView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel

    @State var sixthDayImageComplete: Bool = false
    @State var selectedPickerImage: [PhotosPickerItem] = []
    @State var isImagePickerPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomRounedGradientProgressBar(currentScreen: 8, total: onboardingPageCnt)
                .padding(.top, 30)
                .padding(.bottom, 48)
            Text("매칭된 상대에게 6일차에 공개할 사진을 등록해주세요")
                .font(.pixel(24))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(Color.blackColor)
            Text("흥미있는 대화를 위한 사진입니다.\n6일차에 보여주고 싶은 나의 모습을 등록해주세요")
                .font(.pixel(14))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(Color.gray3)
                .padding(.bottom, 36)
            sixthDayImage
                .padding(.bottom, 70)
            Button(action: {

            }, label: {
                SelectButtonLabel(isSelected: $sixthDayImageComplete, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
        .onAppear {
            if viewModel.selectedSixthDayImage != nil {
                sixthDayImageComplete = true
            }
        }
    }
    
    var sixthDayImage: some View {
        Button {
            isImagePickerPresented = true
        } label: {
            if let image = viewModel.selectedSixthDayImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 240, height: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 9.57))
            } else {
                RoundedRectangle(cornerRadius: 9.57)
                    .fill(Color.subColor1)
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
            viewModel.loadSelectedImage(imageType: .sixthDay, pickerItem: selectedPickerImage)
        })
        
        .onChange(of: viewModel.selectedSixthDayImage) {
            if viewModel.selectedSixthDayImage != nil {
                sixthDayImageComplete = true
            }
        }
    }
}

#Preview {
    ProfileSixthImageView(viewModel: AccountViewModel())
}
