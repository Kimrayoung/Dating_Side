//
//  SettingView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI
import Kingfisher

@MainActor
struct MyPageView: View {
    @State private var imageList: [String] = ["https://picsum.photos/id/1/200/300", "https://picsum.photos/id/2/200/300", "https://picsum.photos/id/3/200/300", "https://picsum.photos/200/300", "https://picsum.photos/200/300", ""]
    @Binding var selfIntroductText: String
    var body: some View {
        ScrollView {
            VStack {
                #warning("MainPath생성할떄 ProfileViewModel 추가")
                ProfileView(showProfileViewType: .myPage)
                photoView
            }
        }
    }
    
    var photoView: some View {
        VStack {
            Text("내 사진첩")
                .font(.pixel(13))
                .frame(maxWidth: .infinity, alignment: .leading)
            myPhoto
        }
        .padding(.leading, 24)
    }
     
    var myPhoto: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(imageList, id: \.self) { imageUrl in
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
                } //ForEach
            } //HStack
        } //ScrollView
    }
    
}

#Preview {
    MyPageView(selfIntroductText: .constant("hi"))
}
