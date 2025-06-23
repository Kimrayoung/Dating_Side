//
//  ChatView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/03/03.
//

import SwiftUI
import Kingfisher

@MainActor
struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel()
    
    let existFromme: Bool = true
    let imageURL: URL = URL(string: "https://picsum.photos/200/300")!
    let fromMeName: String = "일이삼사오육칠팔"
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    let toMeArr: [TomeUserProfile] = [TomeUserProfile(userName: "user1", userImage: "https://picsum.photos/200/300", userType: "따뜻하게 배려하는 연애"), TomeUserProfile(userName: "user2", userImage: "https://picsum.photos/200/300", userType: "따뜻하게 배려하는 연애"), TomeUserProfile(userName: "user3", userImage: "https://picsum.photos/200/300", userType: "따뜻하게 배려하는 연애"), TomeUserProfile(userName: "user4", userImage: "https://picsum.photos/200/300", userType: "따뜻하게 배려하는 연애"), TomeUserProfile(userName: "user5", userImage: "https://picsum.photos/200/300", userType: "따뜻하게 배려하는 연애"), TomeUserProfile(userName: "user6", userImage: "https://picsum.photos/200/300", userType: "따뜻하게 배려하는 연애")]
    
    var body: some View {
        VStack {
            formme
            tome
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Text("채팅")
                    .font(.pixel(20))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Image("bell")
                })
            }
        })
    }
    
    var formme: some View {
        VStack(content: {
            Text("내가 다가간 사람")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
            if existFromme {
                simpleProfile
            } else {
                Text("아직 다가간 사람이 없어요")
                    .font(.pixel(16))
                    .foregroundStyle(Color.gray01)
                    .frame(height: 106, alignment: .center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        })
        .padding(.horizontal, 24)
        .frame(height: 106)
    }
    
    
    var simpleProfile: some View {
        HStack {
            KFImage(imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 72, height: 72)
                .clipShape(Circle())
            VStack(spacing: 4) {
                Text(fromMeName)
                    .font(.pixel(16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                Text("안녕하세요")
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 13)
            Text("자동 취소까지 \(viewModel.timeString)")
                .padding(.vertical, 13)
                .padding(.bottom, 23)
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
        }
    }
    
    var tome: some View {
        VStack(spacing: 0, content: {
            Text("내게 다가온 사람")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
            if toMeArr.isEmpty {
                Spacer()
                Text("아직 다가간 사람이 없어요")
                    .font(.pixel(16))
                    .foregroundStyle(Color.gray01)
                    .frame(height: 106, alignment: .center)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, content: {
                        ForEach(toMeArr, id: \.self) { userProfile in
                            ProfileMiniView(isDefault: false, userImageURL: userProfile.userImage, userName: userProfile.userName, userType: userProfile.userType, widthSize: (UIScreen.main.bounds.width - (24 * 2)) / 2, heightSize: 160)
                        }
                    })
                }
            }
            
        })
        .padding(.horizontal, 24)
    }
    
    func simpleProfile(_ imageUrl: String, _ profileName: String, _ userType: String) -> some View {
        return Button(action: {
            
        }, label: {
            ProfileMiniView(isDefault: false, userImageURL: imageUrl, userName: profileName, userType: userType)
        })
    }
}

#Preview {
    ChatListView()
}
