//
//  ImageOnboardingViewModel.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import SwiftUI
import PhotosUI

class ImageOnboardingViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var selectedPickerImage: PhotosPickerItem?
    @Published var introduceText: String = ""
    @Published var isImagePickerPresented: Bool = false
    
    func loadSelectedImage() {
        guard let item = selectedPickerImage else { return }
        
        item.loadTransferable(type: Data.self, completionHandler: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        self.selectedImage = image
                    }
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error)")
                }
            }
        })
    }
}
