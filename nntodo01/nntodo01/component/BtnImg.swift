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
    private let action: () -> Void
    
    init(_ imgName: String = "",
         color: Color = .black,
         action: @escaping () -> Void) {
        self.imgName = imgName
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ImgSafe(imgName, color: color)
        }
    }
}

#Preview {
    BtnImg() {
        NnLogger.log("BtnImg(preview) was tapped.", level: .debug)
    }
}
