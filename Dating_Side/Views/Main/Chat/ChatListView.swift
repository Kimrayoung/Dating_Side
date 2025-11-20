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
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel = ChatListViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @AppStorage("matchingStatus") private var matchingStatus: String = MatchingStatusType.UNMATCHED.rawValue
    @AppStorage("matchingDate") private var matchingTimeString: String = ""
    @AppStorage("username") private var username: String = ""
    @State var toMeArr: [AttractionPartnerData] = []
    @State var selectedPartner: PartnerAccount? = nil
    @State var formMeAccount: AttractionPartnerData? = nil
    @State var chattingRoomData: ChattingRoomResponse? = nil
    @State private var showProfile: Bool = false
    @State private var showGoodByeView: Bool = false
    @State private var showLeaveAlert: Bool = false
    @State private var allowGoodbyeDismiss: Bool = false
    
    var body: some View {
        VStack {
            if matchingStatus == MatchingStatusType.UNMATCHED.rawValue || matchingStatus == MatchingStatusType.LEFT.rawValue {
                formme
                tome
            } else if matchingStatus == MatchingStatusType.MATCHED.rawValue , let chattingRoomData = chattingRoomData {
                matchingSimpleProfile(chattingRoomData: chattingRoomData)
                    .padding(.vertical, 32)
                    .padding(.horizontal, 24)
                    .onTapGesture {
                        appState.chatPath.append(Chating.chatRoom(roomId: chattingRoomData.roomId, partnerName: chattingRoomData.partnerNickName, partnerImageUrl: chattingRoomData.partnerProfileImageUrl))
                    }
                matchingSuccessImageView
                Spacer()
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Text("채팅")
                    .font(.pixel(20))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    appState.chatPath.append(Chating.noticeView)
                }, label: {
                    Image("bell")
                })
            }
        })
        .task {
            selectedPartner = nil
            toMeArr = await viewModel.senderAttraction()
            formMeAccount = await viewModel.receiverAttraction().first
            print(#fileID, #function, #line, "- matchingStatus: \(matchingStatus)")
            // 매칭된 사람이 있음
            if matchingStatus == MatchingStatusType.MATCHED.rawValue {
                chattingRoomData = await viewModel.chattingRoomRequest()
                guard let matchedAt = matchingTimeString.toDate() else { return }
                let passedDate = matchedAt.daysSince(matchedAt, in: .current)
                let checkpassedDate = matchedAt.hasPassed(days: 2, since: Date())
                Log.debugPublic("몇일이나 지났는지 확인", matchedAt, checkpassedDate, passedDate, matchingTimeString)
                
            } else if matchingStatus == MatchingStatusType.LEFT.rawValue { // 매칭된 사람이 떠남
                showLeaveAlert = true
            }
        }
        .customAlert(isPresented: $showLeaveAlert, title: "상대가 채팅방을 떠났습니다", message: "상대에게 마지막 인사를 남겨주세요", primaryButtonText: "확인", primaryButtonAction: {
            allowGoodbyeDismiss = true // 확인 누를 때만 닫히도록
            showGoodByeView = true
        })
        .sheet(item: $selectedPartner) { partner in
            PartnerProfileView(
                profileShow: .constant(false),
                needMathcingRequest: .chattingRequestMatch,
                matchingPartnerTempAccount: partner
            )
            .presentationDetents([.fraction(0.99)])
            .presentationCornerRadius(10)
            .presentationDragIndicator(.visible)
            .interactiveDismissDisabled(!allowGoodbyeDismiss)
            .onSubmit {
                allowGoodbyeDismiss = false
            }
        }
        //        .sheet(isPresented: $showGoodByeView) {
        //            SayGoodbyeView(chatingViewModel: vm)
        //                .presentationDetents([.height(300)])
        //                .presentationCornerRadius(10)
        //                .presentationDragIndicator(.visible)
        //        }
    }
    
    // 내가 다가간 사람
    var formme: some View {
        VStack(content: {
            Text("내가 다가간 사람")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let profile = formMeAccount {
                simpleProfile(profile.partnerInfo)
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
                            simpleTomeProfile(userProfile.partnerInfo)
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
            KFImage(URL(string: chattingRoomData.partnerProfileImageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 72, height: 72)
                .clipShape(Circle())
            VStack {
                Text(chattingRoomData.partnerNickName)
                    .font(.pixel(16))
                Text(chattingRoomData.lastMessage ?? "")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text(chattingRoomData.timestampDate?.hourAndMinuteString ?? "")
                    .font(.pixel(12))
                    .foregroundStyle(Color.gray3)
                if chattingRoomData.notReadMessageCount > 0 {
                    Text("\(chattingRoomData.notReadMessageCount)")
                        .font(.pixel(14))
                        .foregroundStyle(Color.whiteColor)
                        .frame(width: 28, height: 28)
                        .background(Color.mainColor)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    var matchingSuccessImageView: some View {
        VStack {
            Text("\(chattingRoomData?.partnerNickName ?? "")님과 매칭 된 지 1일차")
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
