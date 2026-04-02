//
//  BtnImg.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct BtnImg: View {
    //init
    private let imgName: String
    private let color: Color
    private let size: CGFloat
    private let action: () -> Void
    
    init(_ imgName: String = "",
         color: Color = .black,
         size: CGFloat = 25,
         action: @escaping () -> Void) {
        self.imgName = imgName
        self.color = color
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                ImgSafe(imgName, color: color)
                    .frame(width: size, height: size)
            }
            .frame(width: 25, height: 25)
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
    BtnImg("iconPlus") {
        NnLogger.log("BtnImg(preview) was tapped.", level: .debug)
    }
}
