import SwiftUI
import UIKit

struct OneDigitTextField: UIViewRepresentable {
    @Binding var text: String
    var isFocused: Bool
    var onCommit: () -> Void
    var alreadyFilled: (_ text: String) -> Void
    var onBackspace: () -> Void
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: OneDigitTextField
        
        init(parent: OneDigitTextField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string == "" {
                // 백스페이스
                textField.text = ""
                parent.text = ""
                parent.onBackspace()
                return false
            }
            if let firstChar = string.first, string.count == 1, firstChar.isNumber {
                if !parent.text.isEmpty {
                    // 현재 칸이 이미 차있으면 → 다음 칸으로 이동 + 입력 넘기기
                    parent.alreadyFilled(String(firstChar))  // 포커스를 다음 칸으로 옮기는 트리거
                    return false // 현재 텍스트 필드는 안 바꾸고 넘김
                } else {
                    // 현재 칸이 비어있으면 → 현재 칸에 입력하고 다음으로 이동
                    textField.text = String(firstChar)
                    parent.text = String(firstChar)
                    parent.onCommit()
                    return false
                }
            }
            return false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> BackspaceTextField {
        let tf = BackspaceTextField()
        tf.delegate = context.coordinator
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.font = UIFont.init(name: "Moneygraphy-Pixel", size: 24)
        tf.borderStyle = .none
        tf.onBackspace = {
            context.coordinator.parent.onBackspace()
        }
        return tf
    }
    
    func updateUIView(_ uiView: BackspaceTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        DispatchQueue.main.async {
            if isFocused && !uiView.isFirstResponder {
                uiView.becomeFirstResponder()
            } else if !isFocused && uiView.isFirstResponder {
                uiView.becomeFirstResponder()
            }
        }
    }
}

// MARK: - 서브클래싱된 UITextField
class BackspaceTextField: UITextField {
    var onBackspace: (() -> Void)?
    
    override func deleteBackward() {
        super.deleteBackward()
        onBackspace?()
    }
}
