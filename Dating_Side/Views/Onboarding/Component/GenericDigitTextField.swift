// DigitalInputField.swift
import SwiftUI

public struct GenericDigitTextField<T: OneDigitalTextField>: View {
    @Binding private var text: String
    private let focusField: T
    private let isFocused: Bool // 필드가 현재 포커스되어 있는지 여부
    private let onCommit: () -> Void
    private let onBackspace: () -> Void
    private let requestFocus: () -> Void // 포커스 요청을 위한 클로저
    
    public init(
        text: Binding<String>,
        focusField: T,
        isFocused: Bool,
        onCommit: @escaping () -> Void,
        onBackspace: @escaping () -> Void,
        requestFocus: @escaping () -> Void
    ) {
        self._text = text
        self.focusField = focusField
        self.isFocused = isFocused
        self.onCommit = onCommit
        self.onBackspace = onBackspace
        self.requestFocus = requestFocus
    }
    
    public var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            if text.isEmpty && !isFocused {
                Text("0")
                    .bottomBorder(color: Color.clear, width: 2, bottomPadding: 1)
                    .font(.pixel(24))
                    .foregroundStyle(Color.gray01)
                    .frame(width: 16, height: 34, alignment: .center)
            }
            OneDigitTextField(
                text: $text,
                isFocused: isFocused,
                onCommit: onCommit,
                alreadyFilled: { text in
                    
                },
                onBackspace: {
                    if text.isEmpty {
                        onBackspace()
                    }
                }
            )
            .bottomBorder(color: Color.gray3, width: 2, bottomPadding: 5)
            .frame(width: 16, height: 34)
            .background(Color.clear)
            .onTapGesture {
                requestFocus()
            }
        })
    }
}
