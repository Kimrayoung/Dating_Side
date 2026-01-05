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
    @State private var showLeaveAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var allowGoodbyeDismiss: Bool = false
    @State private var messageFromLeavePartner: Bool = true
    @State private var matchingPassedDate: Int = 1
    
    
    var body: some View {
        VStack {
            if matchingStatus == MatchingStatusType.UNMATCHED.rawValue || matchingStatus == MatchingStatusType.LEFT.rawValue || matchingStatus == MatchingStatusType.DELETED.rawValue{
                formme
                tome
            } else if matchingStatus == MatchingStatusType.MATCHED.rawValue, let chattingRoomData = chattingRoomData {
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
        .onChange(of: matchingStatus) { _, _ in
            Task {
                await updateStatus()
            }
        }
        .task {
            await viewModel.fetchMatchingStatus()
            await updateStatus()
        }
        .customAlert(isPresented: $showLeaveAlert, title: "상대가 채팅방을 떠났습니다", message: "상대에게 마지막 인사를 남겨주세요", primaryButtonText: "확인", primaryButtonAction: {
            allowGoodbyeDismiss = true // 확인 누를 때만 닫히도록
            viewModel.showGoodByeView = true
        })
        .customAlert(isPresented: $showDeleteAlert, title: "상대가 대화중 탈퇴하였습니다.", message: "탈퇴한 회원과의 채팅방은 사라집니다.", primaryButtonText: "확인", primaryButtonAction: {
            showDeleteAlert = false
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
        .sheet(isPresented: $viewModel.showGoodByeView) {
            SayGoodbyeView { score, comment in
                await viewModel.replyGoodbye(score: score, comment: comment)
            }
            .presentationDetents([.height(300)])
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
    
    ///status에 따른 화면 전환
    func updateStatus() async {
        if matchingStatus == MatchingStatusType.MATCHED.rawValue {
            chattingRoomData = await viewModel.chattingRoomRequest()
            
            if let matchedAt = matchingTimeString.toDate() {
                self.matchingPassedDate = matchedAt.daysSince(matchedAt, in: .current)
                if self.matchingPassedDate >= 7 {
                    await viewModel.matchingPartnerAllPhoto()
                } else {
                    await viewModel.matchingPartnerPhoto()
                }
            }
            
        } else {
            chattingRoomData = nil
            selectedPartner = nil
            
            toMeArr = await viewModel.senderAttraction()
            formMeAccount = await viewModel.receiverAttraction().first
            
            if matchingStatus == MatchingStatusType.LEFT.rawValue {
                showLeaveAlert = true
            } else if matchingStatus == MatchingStatusType.DELETED.rawValue {
                showDeleteAlert = true
            }
        }
    }
    
    var matchingSuccessImageView: some View {
        VStack {
            Text("\(chattingRoomData?.partnerNickName ?? "")님과 매칭 된 지 \(matchingPassedDate)일차")
                .font(.pixel(20))
                .foregroundStyle(Color.blackColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
            
            Text("상대의 의미있는 순간들 입니다:) 깊은 대화에 도움이 될거에요.")
                .font(.pixel(12))
                .foregroundStyle(Color.gray3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .bottom], 24)
            
            ///7일이 되어 모든 사진이 보일때
            if matchingPassedDate >= 7 {
                if let images = viewModel.matchingAllImage, !images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16.5) {
                            ForEach(0..<images.count, id: \.self){ index in
                                let images = images[index]
                                
                                PartnerImageView(
                                    imageUrl: images.profileImageURL,
                                    locked: false,
                                    filledColor: Color.clear
                                )
                                
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                }
                ///7일이 되기 전까지 1장씩 사진이 보일 때
            }else{
                ZStack(alignment: .leading) {
                    if matchingPassedDate < 7 {
                        PartnerImageView(
                            imageUrl: matchingPassedDate >= 6 ? viewModel.matchingImage?.profileImageURL : nil,
                            locked: false,
                            filledColor: .subColor2
                        )
                        .padding(.leading, matchingPassedDate == 1 ? 72 : (matchingPassedDate >= 6 ? 0 : (matchingPassedDate >= 4 ? 24 : 48)))
                        .zIndex(0)
                    }
                    
                    if matchingPassedDate < 6 {
                        PartnerImageView(
                            imageUrl: matchingPassedDate >= 4 ? viewModel.matchingImage?.profileImageURL : nil,
                            locked: false,
                            filledColor: .subColor1
                        )
                        .padding(.leading, matchingPassedDate == 1 ? 48 : (matchingPassedDate >= 4 ? 0 : 24))
                        .zIndex(1)
                    }
                    
                    if matchingPassedDate < 4 {
                        PartnerImageView(
                            imageUrl: matchingPassedDate >= 2 ? viewModel.matchingImage?.profileImageURL : nil,
                            locked: false,
                            filledColor: .subColor
                        )
                        .padding(.leading, matchingPassedDate == 1 ? 24 : 0)
                        .zIndex(2)
                    }
                    
                    if matchingPassedDate <= 1 {
                        PartnerImageView(
                            imageUrl: nil,
                            locked: true,
                            filledColor: .mainColor
                        )
                        .padding(.leading, 0)
                        .zIndex(3)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct PartnerImageView: View {
    let imageUrl: String?
    let locked: Bool
    let filledColor: Color?
    
    var body: some View {
        ZStack {
            if let color = filledColor {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
            }
            
            if locked {
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
            } else {
                if let urlString = imageUrl, let url = URL(string: urlString) {
                    KFImage(url)
                        .resizable()
                        .placeholder {
                            Image("checkerImage")
                        }
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
            }
        }
        .frame(width: 240, height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ChatListView()
}
