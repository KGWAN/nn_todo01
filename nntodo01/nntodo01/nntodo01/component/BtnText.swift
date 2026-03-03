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
                .font(Font.system(size: 20, weight: .medium))
                .foregroundColor(.black)
                .padding(.vertical, 10)
        }
    }
}

#Preview {
    BtnText("title", action: {
        print("btn was tapped.")
    })
}
