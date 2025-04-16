import SwiftUI
import UIKit

struct OneDigitTextField: UIViewRepresentable {
    @Binding var text: String
    var isFocused: Bool
    var onCommit: () -> Void
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
                textField.text = String(firstChar)
                parent.text = String(firstChar)
                parent.onCommit()
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
