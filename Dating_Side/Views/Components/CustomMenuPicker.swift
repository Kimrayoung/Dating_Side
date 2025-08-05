//
//  CustomMenuPicker.swift
//  Dating_Side
//
//  Created by 김라영 on 8/3/25.
//

import SwiftUI

struct CustomMenuPicker<T: Identifiable & CustomStringConvertible>: View {
    let title: String
    let options: [T]
    @Binding var selectedIndex: Int?
    var placeholder: String = "선택해주세요"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.pixel(17))
                .foregroundColor(.black)
            
            Menu {
                ForEach(options.indices, id: \.self) { idx in
                    Button(options[idx].description) {
                        selectedIndex = idx
                    }
                }
            } label: {
                HStack {
                    Text(selectedIndex == nil ? placeholder : options[selectedIndex ?? 0].description)
                        .font(.pixel(17))
                        .foregroundColor(selectedIndex == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(16)
                .frame(height: 59)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(14)
            }
        }
    }
}

