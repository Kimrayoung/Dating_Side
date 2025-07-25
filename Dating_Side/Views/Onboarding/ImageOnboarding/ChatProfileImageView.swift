//
//  ChatProfileImageView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import SwiftUI
import PhotosUI

/// 프로필 사진 등록 및 자기소개 등록
struct ChatProfileImageView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var alertManager: AlertManager
    @ObservedObject var viewModel: OnboardingViewModel
    @State var possibleNext: Bool = false
    @State var selectedPickerImage: [PhotosPickerItem] = []
    @State var isImagePickerPresented: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            // 2) 투명 배경을 탭하면 포커스 해제
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = false
                }
            
            VStack {
                CustomRounedGradientProgressBar(currentScreen: 13, total: onboardingPageCnt)
                    .padding(.top, 30)
                    .padding(.bottom, 48)
                
                Text("프로필 사진을 등록 해주세요")
                    .font(.pixel(24))
                    .foregroundStyle(Color.blackColor)
                    .multilineTextAlignment(.center)
                
                Text("매칭 때 보여지는 유일한 사진 입니다\n얼굴이 잘 나온 사진으로 등록해주세요")
                    .font(.pixel(14))
                    .foregroundStyle(Color.gray3)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 36)
                
                profileImage
                Text("작은 크기로만 볼 수 있어 부담이 적어요")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
                    .padding(.bottom, 16)
                
                selectImageButton
                    .padding(.bottom, 48)
                
                // 3) TextEditor 뷰에도 FocusState 연결
                selfIntroduceTextView
                
                Spacer()
                
                Button {
                    guard viewModel.selectedImage != nil else { return }
                    appState.onboardingPath.append(Onboarding.secondDayPhoto)
                } label: {
                    SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom)
            }
        }
        .ignoresSafeArea(.keyboard)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    isFocused = false
                }
            }
        }
        .alert(isPresented: $alertManager.isPresented) {
            Alert(
                title: Text(alertManager.title),
                message: Text(alertManager.message),
                dismissButton: alertManager.button
            )
        }
        .onChange(of: viewModel.selectedImage) { _, newValue in
            possibleNext = (newValue != nil)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // 뒤로 가기 전 키보드 내리고
                    isFocused = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        appState.onboardingPath.removeLast()
                    }
                } label: {
                    Image("navigationBackBtn")
                }
            }
        }
    }
    
    var profileImage: some View {
        Group {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
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
        PhotoPickerButton(
            imageType: .mainProfile,
            isPresented: $isImagePickerPresented,
            selectedPickerImage: $selectedPickerImage,
            onImagePicked: { item in
                viewModel.loadSelectedImage(imageType: .mainProfile, pickerItem: item)
            }) {
                Text("사진 선택하기")
                    .foregroundStyle(Color.black)
                    .font(.pixel(14))
                    .padding(.vertical, 9.5)
                    .padding(.horizontal, 24.5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    }
            }.onChange(of: viewModel.selectedImage) {
                if viewModel.selectedImage != nil {
                    possibleNext = true
                }
            }
    }
    
    var selfIntroduceTextView: some View {
        ZStack(content: {
            TextEditor(text: $viewModel.introduceText)
                .focused($isFocused)
                .submitLabel(.done)
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
        .onSubmit {
            isFocused = false
        }
        .frame(height: 200)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ChatProfileImageView(viewModel: OnboardingViewModel())
}

