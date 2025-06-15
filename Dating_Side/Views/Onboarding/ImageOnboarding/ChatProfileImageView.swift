//
//  ChatProfileImageView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import SwiftUI

struct ChatProfileImageView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: ImageOnboardingViewModel
    @State var possibleNext: Bool = true
    
    var body: some View {
        CustomRounedGradientProgressBar(currentScreen: 8, total: onboardingPageCnt)
            .padding(.top, 30)
            .padding(.bottom, 48)
        Text("프로필 사진을 등록 해주세요")
            .font(.pixel(24))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(Color.blackColor)
        Text("매칭 때 보여지는 유일한 사진 입니다\n얼굴이 잘 나온 사진으로 등록해주세요")
            .font(.pixel(14))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(Color.gray3)
            .padding(.bottom, 36)
        profileImage
        Text("작은 크기로만 볼 수 있어 부담이 적어요")
            .font(.pixel(12))
            .foregroundStyle(Color.gray3)
            .padding(.bottom, 16)
        selectImageButton
            .padding(.bottom, 48)
        selfIntroduceTextView
        Spacer()
        Button(action: {
            
        }, label: {
            SelectButtonLabel(isSelected: $possibleNext, height: 42, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
        })
        .padding(.bottom)
        .padding(.horizontal, 24)
    }
    
    var profileImage: some View {
        Group {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                    .padding(.bottom, 12)
            } else {
                Image("defaultProfileImage")
                    .frame(width: 72, height: 72)
                    .padding(.bottom, 12)
            }
        }
    }
    
    var selectImageButton: some View {
        Button(action: {
            viewModel.isImagePickerPresented = true
        }, label: {
            Text("사진 선택하기")
                .foregroundStyle(Color.black)
                .font(.pixel(14))
        })
        .padding(.vertical, 9.5)
        .padding(.horizontal, 24.5)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
        }
        .onChange(of: viewModel.selectedPickerImage, {
            viewModel.loadSelectedImage()
        })
        
        .onChange(of: viewModel.selectedImage) {
            if viewModel.selectedImage != nil {
                possibleNext = true
            }
        }
    }
    
    var selfIntroduceTextView: some View {
        ZStack(content: {
            TextEditor(text: $viewModel.introduceText)
                .font(.pixel(12))
                .foregroundStyle(Color.gray01)
                .padding([.top, .leading], 9)
                .frame(height: 200)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray01, lineWidth: 1)
                }
                
            if viewModel.introduceText == "" {
                Text("자기소개로 자신을 더욱 어필 해보세요")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray01)
                    .padding([.top, .leading], 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    
            }
        })
        .frame(height: 200)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ChatProfileImageView(viewModel: ImageOnboardingViewModel())
}
