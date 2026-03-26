//
//  BtnImg.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct BtnImgConditional: View {
    // in
    private let nameImg: String
    private let isEnabled: Bool
    private let action: () -> Void
    // init
    init (
        nameImg: String = "no_img",
        isEnabled: Bool,
        action: @escaping () -> Void
        ) {
        self.action = action
        self.isEnabled = isEnabled
        self.nameImg = nameImg
    }
    
    var body: some View {
        Button {
            if isEnabled {
                action()
            }
        } label: {
            ImgShift(
                nameImg,
                colorY: .cyan,
                colorN: .gray,
                isY: isEnabled
            )
            .frame(width: 22.5, height: 22.5)
            .padding(2.5)
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
    BtnImgConditional(
        isEnabled: true
    ) {
        print("touched.")
    }
    BtnImgConditional(
        isEnabled: false
    ) {
        print("touched.")
    }
}
