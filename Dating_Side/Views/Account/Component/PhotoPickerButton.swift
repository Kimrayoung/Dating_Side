//
//  Untitled.swift
//  Dating_Side
//
//  Created by 김라영 on 7/21/25.
//

import SwiftUI
import PhotosUI

/// 재사용 가능한 사진 선택 버튼 컴포넌트
/// - imageType: 외부에서 정의된 ImageType enum
/// - selectedImage: 선택된 UIImage를 바인딩으로 전달
/// - onImagePicked: 이미지 선택 완료 콜백
/// - label: 버튼의 레이블을 커스터마이징할 클로저
struct PhotoPickerButton<Label: View>: View {
    let imageType: ImageType
    @Binding var isPresented: Bool
    @Binding var selectedPickerImage: [PhotosPickerItem]
    @Binding var showAlert: Bool
    var maxSelectionCount: Int = 1
    let onImagePicked: ([PhotosPickerItem]) -> Void
    let label: () -> Label

    var body: some View {
        Button {
            // 필요 시 퍼미션 처리 로직 추가 가능
            PermissionManager.shared.requestPhotoLibraryAccess { granted in
                if granted { isPresented = true }
                else {
                    showAlert = true
                }
            }
        } label: {
            label()
        }
        .photosPicker(
            isPresented: $isPresented,
            selection: $selectedPickerImage,
            maxSelectionCount: 1,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPickerImage) { oldValue, newValue in
            onImagePicked(newValue)
        }
        
    }
}
