//
//  BtnText.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import SwiftUI

struct BtnText: View {
    let text: String
    let action: () -> Void
    
    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(Font.system(size: 18, weight: .medium))
                .foregroundColor(.black)
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
    }
}

#Preview {
    BtnText("title", action: {
        print("btn was tapped.")
    })
}
