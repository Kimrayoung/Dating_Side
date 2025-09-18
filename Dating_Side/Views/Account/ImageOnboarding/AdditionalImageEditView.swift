//
//  AdditionalImageEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 9/4/25.
//

import SwiftUI
import Kingfisher
import PhotosUI

/// 추가 사진 변경
struct AdditionalImageEditView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel = AccountViewModel()
    @State var selectedPickerImage: [PhotosPickerItem] = []
    @State var isImagePickerPresented: Bool = false
    @State var showAlert: Bool = false
    @State private var possibleNext: Bool = true
    /// 온보딩에서 수정하는 건지
    var isOnboarding: Bool = false
    var profileImageUrl: ProfileImageURLByDay?
    
    var body: some View {
        VStack {
            Text("추가사진 변경")
                .font(.pixel(24))
                .padding(.top, 30)
            Text("수정하고 싶은 일차의 사진을 클릭해서\n새로운 사진을 등록 해주세요")
                .font(.pixel(14))
            ScrollView(.horizontal) {
                HStack {
                    secondImageView
                        .padding(.leading, 77)
                    forthImageView
                    sixthImageView
                        .padding(.trailing, 77)
                }
            }
            
            .padding(.top, 51)
            .padding(.bottom, 85)
            Button(action: {
                if viewModel.isOnboarding == .mypageEdit {
                    
                } else if viewModel.isOnboarding == .onboardingEdit {
                    appState.onboardingPath.removeLast()
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "저장", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
    }
    
    func buildImageView(
        localImage: UIImage?,     // 온보딩일 때 쓸 UIImage
        urlString: String?        // 온보딩 아닐 때 쓸 URL string
    ) -> some View {
        Group {
            if isOnboarding {
                if let uiImage = localImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image("checkmark")
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            } else {
                if let urlString = urlString,
                   let url = URL(string: urlString) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image("checkmark")
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    
    var secondImageView: some View {
        VStack {
            Text("2일차")
                .font(.pixel(24))
                .foregroundStyle(Color.mainColor)
            PhotoPickerButton(imageType: .secondDay, isPresented: $isImagePickerPresented, selectedPickerImage: $selectedPickerImage, showAlert: $showAlert) { item in
                Task {
                    await viewModel.loadSelectedImage(imageType: .secondDay, pickerItem: item)
                }
            } label: {
                buildImageView(localImage: viewModel.selectedSeconDayImage, urlString: profileImageUrl?.daySecond)
            }
        }
    }
    
    var forthImageView: some View {
        VStack {
            Text("4일차")
                .font(.pixel(24))
                .foregroundStyle(Color.mainColor)
            PhotoPickerButton(imageType: .forthDay, isPresented: $isImagePickerPresented, selectedPickerImage: $selectedPickerImage, showAlert: $showAlert) { item in
                Task {
                    await viewModel.loadSelectedImage(imageType: .forthDay, pickerItem: item)
                }
            } label: {
                buildImageView(localImage: viewModel.selectedForthDayImage, urlString: profileImageUrl?.dayFourth)
            }
        }
    }
    
    var sixthImageView: some View {
        VStack {
            Text("6일차")
                .font(.pixel(24))
                .foregroundStyle(Color.mainColor)
            PhotoPickerButton(imageType: .sixthDay, isPresented: $isImagePickerPresented, selectedPickerImage: $selectedPickerImage, showAlert: $showAlert) { item in
                Task {
                    await viewModel.loadSelectedImage(imageType: .sixthDay, pickerItem: item)
                }
            } label: {
                buildImageView(localImage: viewModel.selectedSixthDayImage, urlString: profileImageUrl?.daySixth)
            }
        }
    }
    
}

#Preview {
    AdditionalImageEditView(profileImageUrl: ProfileImageURLByDay(daySecond: "", dayFourth: "", daySixth: ""))
}
