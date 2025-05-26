//
//  ChatProfileAddImageVie.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/19.
//

import SwiftUI

struct ChatProfileAddImageView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: ImageOnboardingViewModel
    @State var secondDayImageComplete: Bool = false
    @State var forthDayImageComplete: Bool = false
    @State var sixthDayImageComplete: Bool = false
    
    var body: some View {
        CustomRounedGradientProgressBar(currentScreen: 8, total: onboardingPageCnt)
            .padding(.top, 30)
            .padding(.bottom, 48)
        Text("매칭된 상대에게 2일차에 공개할 사진을 등록해주세요")
            .font(.pixel(24))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(Color.blackColor)
        Text("흥미있는 대화를 위한 사진입니다.\n3일차에 보여주고 싶은 나의 모습을 등록해주세요")
            .font(.pixel(14))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(Color.gray3)
            .padding(.bottom, 36)
        ZStack {
            sixthDayImage
            forthDayImage
            secondDayImage
        }
    }
    
    var secondDayImage: some View {
        Group {
            Button {
                print(#fileID, #function, #line, "- <#comment#>")
            } label: {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 9.57))
                } else {
                    Image("checkerImage")
                        .frame(width: 240, height: 360)
                }
            }
        }
    }
    
    var forthDayImage: some View {
        Group {
            Button {
                print(#fileID, #function, #line, "- <#comment#>")
            } label: {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 9.57))
                        .padding(.leading, 16)
                } else {
                    RoundedRectangle(cornerRadius: 9.57)
                        .fill(Color.subColor)
                        .frame(width: 240, height: 360)
                        .padding(.leading, 16)
                }
            }
        }
    }
    
    var sixthDayImage: some View {
        Group {
            Button {
                print(#fileID, #function, #line, "- <#comment#>")
            } label: {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 240, height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 9.57))
                        .padding(.leading, 30)
                } else {
                    RoundedRectangle(cornerRadius: 9.57)
                        .fill(Color.subColor1)
                        .frame(width: 240, height: 360)
                        .padding(.leading, 30)
                }
            }
        }
    }
}

#Preview {
    ChatProfileAddImageView(viewModel: ImageOnboardingViewModel())
}
