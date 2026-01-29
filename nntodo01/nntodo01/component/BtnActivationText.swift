//
//  BtnActivationText.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import SwiftUI

struct BtnActivationText: View {
    let text: String
    @Binding var isEnabled: Bool
    let action: () -> Void
    
    init(_ text: String, isEnabled: Binding<Bool> ,action: @escaping () -> Void) {
        self.text = text
        self._isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(Font.system(size: 20))
                .foregroundColor(isEnabled ? .black : .gray)
                .padding(.vertical, 10)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    @Previewable @State var isActive: Bool = true
    
    BtnActivationText(
        "text",
        isEnabled: $isActive,
        action: {
            print("btn was tapped.")
        }
    )
}
