//
//  ProfileAddImageEditView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/13/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

/// 추가 이미지 편집 뷰
struct ProfileAddImageEditView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: AccountViewModel
    @State var isImagePickerPresented: Bool = false
    @State var selectedPickerImage: [PhotosPickerItem] = []
    @State private var showAlert: Bool = false
    var profileImageUrlList: [String]
    
    var body: some View {
        VStack {
            myPhoto
            editPhotoButton
            saveButton
        }
    }
    /*
     이거를 수정하기 버튼이 아니라 이미지 위해 수정 버튼을 누르게 하는게 나을 것 같은데
     */
    
    var myPhoto: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(profileImageUrlList, id: \.self) { imageUrl in
                    if let url = URL(string: imageUrl) {
                        KFImage(url)
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
            } //HStack
        } //ScrollView
    }
    
    var saveButton: some View {
        Button {
            Task {
                await viewModel.updateAdditionalImage()
            }
            
        } label: {
            Text("저장")
                .font(.pixel(14))
        }
    }
    
    var editPhotoButton: some View {
        PhotoPickerButton(imageType: .additionalImageEdit, isPresented: $isImagePickerPresented, selectedPickerImage: $selectedPickerImage, showAlert: $showAlert, maxSelectionCount: 3, onImagePicked: { items in
            Task {
                await viewModel.loadSelectedImage(imageType: .sixthDay, pickerItem: items)
            }
        }, label: {
            Text("사진 고르기")
                .font(.pixel(14))
        })
    }
}

#Preview {
    ProfileAddImageEditView(viewModel: AccountViewModel(), profileImageUrlList: [])
}
