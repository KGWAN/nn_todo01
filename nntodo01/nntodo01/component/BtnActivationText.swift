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
                .font(Font.system(size: 18, weight: isEnabled ? .bold : .medium))
                .foregroundColor(isEnabled ? .cyan : .gray)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                .padding(2.5)
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
