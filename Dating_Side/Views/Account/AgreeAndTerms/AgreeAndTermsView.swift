//
//  AgreeAndTermsView.swift
//  Dating_Side
//
//  Created by 김라영 on 8/30/25.
//

import SwiftUI

struct AgreeAndTermsView: View {
    @EnvironmentObject private var appState: AppState
    let termsURL: String = "https://ivy-soapwort-586.notion.site/22280646722e80d3ba4cfe89d2270d51?source=copy_link"
    let privacyURL: String = "https://ivy-soapwort-586.notion.site/22280646722e809ba584f1828e663f74?source=copy_link"
    
    @State private var allAgree = false
    @State private var isOver14 = false
    @State private var agreeTerms = false
    @State private var agreePrivacy = false
    
    private var allRequiredAgreed: Bool {
        isOver14 && agreeTerms && agreePrivacy
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 제목
                Text("서비스 이용 동의")
                    .font(.pixel(28).bold())
                    .foregroundStyle(Color.blackColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 0) {
                    // 전체 동의
                    headerConsentRow
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            allAgree.toggle()
                            isOver14 = allAgree
                            agreeTerms = allAgree
                            agreePrivacy = allAgree
                        }
                    }
                    .padding(.horizontal, 16)
                    Divider().padding(.horizontal, 24).padding(.top, 12)
                    ageRow
                    appUseRow
                    personalTerm
                    Spacer()
                }
                
                // 다음 버튼
                Button {
                
                } label: {
                    Text("다음")
                        .font(.pixel(16).weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(allRequiredAgreed ? Color.mainColor : Color.gray0)
                        .foregroundStyle(allRequiredAgreed ? Color.white : Color.gray2)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                .disabled(!allRequiredAgreed)
            }
            .onChange(of: isOver14) { _ in syncAll() }
            .onChange(of: agreeTerms) { _ in syncAll() }
            .onChange(of: agreePrivacy) { _ in syncAll() }
        }
    }
    
    private func syncAll() {
        withAnimation { allAgree = isOver14 && agreeTerms && agreePrivacy }
    }
    
    var headerConsentRow: some View {
        HStack(alignment: .top, spacing: 12) {
            CheckIcon(isOn: allAgree)
            VStack(alignment: .leading, spacing: 6) {
                Text("약관 전체 동의")
                    .font(.pixel(20).weight(.semibold))
                    .foregroundStyle(Color.blackColor)
                Text("서비스 이용을 위해 약관에 모두 동의합니다.")
                    .font(.pixel(14))
                    .foregroundStyle(Color.gray2)
            }
            Spacer()
        }
        .padding(.top, 16)
    }
    
    var ageRow: some View {
        CheckRow(isOn: $isOver14, title: "(필수) 만 14세입니다.")
            .onTapGesture { isOver14.toggle(); syncAll() }
            .padding(.top, 12)
            .padding(.horizontal, 30)
    }
    
    var personalTerm: some View {
        HStack(spacing: 0) {
            CheckRow(isOn: $agreePrivacy, title: "(필수) 개인정보 처리방침")
                .simultaneousGesture(TapGesture().onEnded {
                    agreePrivacy.toggle(); syncAll()
                })
            Button {
                appState.onboardingPath.append(Onboarding.webView(url: privacyURL))
            } label: {
                Image("rightArrow") // 프로젝트 에셋
                    .renderingMode(.original)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 16)
    }
    
    var appUseRow: some View {
        HStack(spacing: 0) {
            CheckRow(isOn: $agreeTerms, title: "(필수) 서비스 이용약관")
                .simultaneousGesture(TapGesture().onEnded {
                    agreeTerms.toggle(); syncAll()
                })
            Button {
                appState.onboardingPath.append(Onboarding.webView(url: termsURL))
            } label: {
                Image("rightArrow") // 프로젝트 에셋
                    .renderingMode(.original)
            }
        }
        .padding(.horizontal, 30)
    }
    
}




// MARK: - 프리뷰
#Preview {
    AgreeAndTermsView()
}
