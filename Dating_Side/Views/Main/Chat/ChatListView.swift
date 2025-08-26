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
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    @State var matchingStatus: MatchingStatusType? = nil
    @State var toMeArr: [PartnerAccount] = []
    @State var selectedPartner: PartnerAccount? = nil
    @State var formMeAccount: PartnerAccount? = nil
    @State var chattingRoomData: ChattingRoomResponse? = nil
    @State private var showProfile: Bool = false
    
    var body: some View {
        VStack {
            if matchingStatus == .UNMATCHED {
                formme
                tome
            } else if matchingStatus == .MATCHED , let chattingRoomData = chattingRoomData {
                matchingSimpleProfile(chattingRoomData: chattingRoomData)
                matchingSuccessImageView
            } else {
                EmptyView()
            }
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
        .task {
            selectedPartner = nil
            toMeArr = await viewModel.senderAttraction()
            formMeAccount = await viewModel.receiverAttraction().first
            matchingStatus = await viewModel.fetchMatchingStauts()
            if matchingStatus == .MATCHED {
                chattingRoomData = await viewModel.chattingRoomRequest()
            }
        }
        .sheet(item: $selectedPartner) { partner in
            PartnerProfileView(
                profileShow: .constant(false),
                needMathcingRequest: .chattingRequestMatch,
                matchingPartnerTempAccount: partner
            )
            .presentationDetents([.fraction(0.99)])
            .presentationCornerRadius(10)
            .presentationDragIndicator(.visible)
        }
    }
    
    // 내가 다가간 사람
    var formme: some View {
        VStack(content: {
            Text("내가 다가간 사람")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let profile = formMeAccount {
                simpleProfile(profile)
                    .padding(.vertical, 17)
            } else {
                Text("아직 다가간 사람이 없어요")
                    .font(.pixel(16))
                    .foregroundStyle(Color.gray01)
                    .frame(height: 106, alignment: .center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 17)
            }
        })
        .padding(.horizontal, 24)
        
    }
    
    func simpleProfile(_ userAccount: PartnerAccount) -> some View {
        return HStack {
            KFImage(URL(string: userAccount.profileImageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 72, height: 72)
                .clipShape(Circle())
            VStack(spacing: 4) {
                Text("\(userAccount.nickName)/\(userAccount.birthYear)/\(userAccount.height)")
                    .font(.pixel(16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                Text(userAccount.keyword)
                    .foregroundStyle(Color.mainColor)
                    .font(.pixel(12))
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.mainColor)
                    }
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
                            simpleTomeProfile(userProfile)
                        }
                    })
                }
            }
            
        })
        .padding(.horizontal, 24)
    }
    
    func simpleTomeProfile(_ partnerAccount: PartnerAccount) -> some View {
        return Button(action: {
            selectedPartner = partnerAccount
        }, label: {
            ProfileMiniView(isDefault: false, userImageURL: partnerAccount.profileImageURL, userName: partnerAccount.nickName, userType: partnerAccount.keyword)
        })
    }
    
    func matchingSimpleProfile(chattingRoomData: ChattingRoomResponse) -> some View {
        return HStack {
            KFImage(URL(string: "https://picsum.photos/200/300"))
            VStack {
                Text(chattingRoomData.partnerNickName)
                    .font(.pixel(16))
                Text(chattingRoomData.lastMessage)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text(chattingRoomData.lastMessageTime.hourAndMinuteString)
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
                if chattingRoomData.notReadMessageCount > 0 {
                    Text("\(chattingRoomData.notReadMessageCount)")
                        .font(.pixel(14))
                        .foregroundStyle(Color.whiteColor)
                        .frame(width: 28, height: 28)
                        .background(Color.mainColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    var matchingSuccessImageView: some View {
        VStack {
            Text("윈터님과 매칭 된 지 1일차")
                .font(.pixel(20))
                .foregroundStyle(Color.blackColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
            Text("상대의 의미있는 순간들 입니다:) 깊은 대화에 도움이 될거에요.")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .bottom], 24)
            ZStack {
                sixthDayImage
                forthDayImage
                secondDayImage
                firstDayImage
            }
        }
    }
    
    var firstDayImage: some View {
        ZStack {
            VStack {
                Spacer()
                Text("2일차 부터\n상대의 사진이 보여요")
                    .font(.pixel(16))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.trailing, 70)
                Spacer()
            }
            Image("matchingAdditioanlFirstImage")
        }
        .background(
            RoundedRectangle(cornerRadius: 9.57)
                .fill(Color.mainColor)
        )
        .frame(width: 240, height: 360)
            
    }
    
    var secondDayImage: some View {
        RoundedRectangle(cornerRadius: 9.57)
            .fill(Color.subColor)
            .frame(width: 240, height: 360)
            .padding(.leading, 16)
    }
    
    var forthDayImage: some View {
        RoundedRectangle(cornerRadius: 9.57)
            .fill(Color.subColor1)
            .frame(width: 240, height: 360)
            .padding(.leading, 32)
    }
    
    var sixthDayImage: some View {
        RoundedRectangle(cornerRadius: 9.57)
            .fill(Color.subColor2)
            .frame(width: 240, height: 360)
            .padding(.leading, 48)
    }
    
}

#Preview {
    ChatListView()
}
