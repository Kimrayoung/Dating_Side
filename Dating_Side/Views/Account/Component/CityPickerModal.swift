//
//  CityPickerModal.swift
//  Dating_Side
//
//  Created by 김라영 on 8/3/25.
//

import SwiftUI

struct CityPickerModal: View {
    @ObservedObject var viewModel: AccountViewModel
    @Binding var isPresented: Bool
    @State private var isCompleted: Bool = false
    var title: String
    /// false: 시/도. true: 구/군
    var isDetail: Bool = false
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 4)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleView
            // 시/도 선택 버튼 그리드
            ScrollView {
                if isDetail {
                    detailGrid
                } else {
                    cityGrid
                }
            }
            
            Spacer()
            
            // 확인 버튼
            Button(action: {
                isPresented = false
                if isDetail && viewModel.detailLocationSelected != nil {
                    isCompleted = true
                } else if viewModel.locationSelected != nil {
                    isCompleted = true
                }
            }) {
                SelectButtonLabel(isSelected: $isCompleted, height: 48, text: "다음", backgroundColor: .gray0, selectedBackgroundColor: .mainColor, textColor: Color.gray2, cornerRounded: 8, font: .pixel(14), strokeBorderLineWidth: 0, selectedStrokeBorderLineWidth: 0)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .onChange(of: viewModel.locationSelected, { oldValue, newValue in
            if newValue != nil && !isDetail {
                isCompleted = true
            }
        })
        .onChange(of: viewModel.detailLocationSelected) { oldValue, newValue in
            if newValue != nil && isDetail {
                isCompleted = true
            }
        }
    }
    
    var titleView: some View {
        HStack {
            Text(title)
                .font(.pixel(24))
            Spacer()
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 20)
    }
    
    var cityGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.locationOption, id: \.code) { city in
                Button(action: {
                    viewModel.locationSelected = city
                }) {
                    makeCityButtonLabel(city: city)
                }
            }
        }
        .padding(.horizontal, 14)
    }
    
    var detailGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.detailLocationOption, id: \.code) { city in
                Button(action: {
                    viewModel.detailLocationSelected = city
                }) {
                    makeCityButtonLabel(city: city)
                }
            }
        }
        .padding(.horizontal, 14)
    }
    
    func makeCityButtonLabel(city: Address) -> some View {
        Text(city.addrName)
            .font(.pixel(15))
            .frame(maxWidth: .infinity, minHeight: 38)
            .background(isDetail ? (viewModel.detailLocationSelected == city ? Color.mainColor : Color.white) : (viewModel.locationSelected == city ? Color.mainColor : Color.white))
            .foregroundColor(isDetail ? (viewModel.detailLocationSelected == city ? Color.white : Color.black) : (viewModel.locationSelected == city ? Color.white : Color.black))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray3), lineWidth: 1)
            )
    }
    
}

#Preview {
    CityPickerModal(viewModel: AccountViewModel(), isPresented: .constant(false), title: "시/도")
}
