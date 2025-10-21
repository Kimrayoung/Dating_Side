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
    
    //각각 이미지
    @State private var selectedSecondDayItem: [PhotosPickerItem] = []
    @State private var selectedFourthDayItem: [PhotosPickerItem] = []
    @State private var selectedSixthDayItem: [PhotosPickerItem] = []

    //각각 호출 상태
    @State var isSecondImagePickerPresented: Bool = false
    @State var isForthImagePickerPresented: Bool = false
    @State var isSixthImagePickerPresented: Bool = false
    
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
                .lineLimit(2)
                .multilineTextAlignment(.center)
            ScrollView(.horizontal) {
                HStack {
                    secondImageView
                        .padding(.leading, 77)
                    forthImageView
                    sixthImageView
                        .padding(.trailing, 77)
                }
            }
            .scrollIndicators(.hidden)
            
            .padding(.top, 51)
            .padding(.bottom, 85)
            Button(action: {
                Task{
                    await viewModel.updateAdditionalImage()
                }
            }, label: {
                SelectButtonLabel(isSelected: $possibleNext, height: 48, text: "저장", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            })
            .padding(.bottom)
            .padding(.horizontal, 24)
        }
    }
    
    func buildImageView(
        localImage: UIImage?,      // ViewModel에서 새로 선택된 UIImage (최우선 표시)
        urlString: String?         // 서버에서 가져온 기존 이미지 URL
    ) -> some View {
        Group {
            if isOnboarding {
                if let uiImage = localImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image("checkerImage")
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            } else {
                if let uiImage = localImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else if let urlString = urlString,
                          let url = URL(string: urlString) {
                    KFImage(url)
                        .placeholder {
                            Image("checkerImage")
                                .resizable()
                                .frame(width: 240, height: 360)
                        }
                        .fade(duration: 0.25)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image("checkerImage")
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
    
    //MARK: - 2일차
    var secondImageView: some View {
        VStack {
            Text("2일차")
                .font(.pixel(24))
                .foregroundStyle(Color.mainColor)
            PhotoPickerButton(imageType: .secondDay, isPresented: $isSecondImagePickerPresented, selectedPickerImage: $selectedSecondDayItem, showAlert: $showAlert) { seconditem in
                print("2일 photoPickerButton tapped")
                Task {
                    await viewModel.loadSelectedImage(imageType: .secondDay, pickerItem: seconditem)
                }
            } label: {
                buildImageView(localImage: viewModel.selectedSeconDayImage, urlString: profileImageUrl?.daySecond)
            }
        }
    }
    
    //MARK: - 4일차
    var forthImageView: some View {
        VStack {
            Text("4일차")
                .font(.pixel(24))
                .foregroundStyle(Color.mainColor)
            PhotoPickerButton(imageType: .forthDay, isPresented: $isForthImagePickerPresented, selectedPickerImage: $selectedFourthDayItem, showAlert: $showAlert) { forthitem in
                print("4일 photoPickerButton tapped")
                Task {
                    await viewModel.loadSelectedImage(imageType: .forthDay, pickerItem: forthitem)
                }
            } label: {
                buildImageView(localImage: viewModel.selectedForthDayImage, urlString: profileImageUrl?.dayFourth)
            }
        }
    }
    
    //MARK: - 6일차
    var sixthImageView: some View {
        VStack {
            Text("6일차")
                .font(.pixel(24))
                .foregroundStyle(Color.mainColor)
            PhotoPickerButton(imageType: .sixthDay, isPresented: $isSixthImagePickerPresented, selectedPickerImage: $selectedSixthDayItem, showAlert: $showAlert) { sixthitem in
                print("6일 photoPickerButton tapped")
                Task {
                    await viewModel.loadSelectedImage(imageType: .sixthDay, pickerItem: sixthitem)
                }
            } label: {
                buildImageView(localImage: viewModel.selectedSixthDayImage, urlString: profileImageUrl?.daySixth)
            }
        }
    }
    
}

#Preview {
    AdditionalImageEditView(profileImageUrl: ProfileImageURLByDay(daySecond: "checkerImage", dayFourth: "checkerImage", daySixth: "checkerImage"))
}
