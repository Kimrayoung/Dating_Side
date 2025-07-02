//
//  ValuesListView.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/26.
//

import SwiftUI

/// 가치관 목록 리스트
struct ValuesListView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var valueType: ProfileValueType
    @State private var valueList: [ValueData] = [ValueData(text: "당신은 안정적이며 의지할 수 있는 관계를 중요하게 생각합니다.연애에서는 함께 시간을 보내는 것과 서로의 안정을 우선시하고, 공감하고 이해해주는 파트너를 선호합니다.이전 연애에서는 아마도 깊은 유대감을 형성하려 했을 것이며, 앞으로도 의지할 수 있는 관계를 추구할 것으로 보입니다. 감정 표현에서는 행동으로 마음을 전하는 경향이 있습니다."), ValueData(text: "당신은 안정적이며 의지할 수 있는 관계를 중요하게 생각합니다.연애에서는 함께 시간을 보내는 것과 서로의 안정을 우선시하고, 공감하고 이해해주는 파트너를 선호합니다.이전 연애에서는 아마도 깊은 유대감을 형성하려 했을 것이며, 앞으로도 의지할 수 있는 관계를 추구할 것으로 보입니다. 감정 표현에서는 행동으로 마음을 전하는 경향이 있습니다."), ValueData(text: "당신은 안정적이며 의지할 수 있는 관계를 중요하게 생각합니다.연애에서는 함께 시간을 보내는 것과 서로의 안정을 우선시하고, 공감하고 이해해주는 파트너를 선호합니다.이전 연애에서는 아마도 깊은 유대감을 형성하려 했을 것이며, 앞으로도 의지할 수 있는 관계를 추구할 것으로 보입니다. 감정 표현에서는 행동으로 마음을 전하는 경향이 있습니다.")]
    
    
    var body: some View {
        List(valueList, id:\.self) { value in
            valueText(text: value.text)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("연애")
    }
    
    func valueText(text: String) -> some View {
        return Text(text)
            .font(.pixel(16))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray01, lineWidth: 1) // ✅ border 추가
            )
    }
}

#Preview {
    ValuesListView(viewModel: ProfileViewModel(), valueType: .company)
}
