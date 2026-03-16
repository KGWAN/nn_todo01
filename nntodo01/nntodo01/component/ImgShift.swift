//
//  ImgShift.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ImgShift: View {
    // init
    init(
        _ imgName: String = "noImg",
        colorY: Color = .cyan,
        colorN: Color = .gray,
        isY: Bool,
    ) {
        self.isY = isY
        self.imgName = imgName
        self.colorY = colorY
        self.colorN = colorN
    }
    // in value
    private let imgName: String
    private let colorY: Color
    private let colorN: Color
    private let isY: Bool
    
    
    var body: some View {
        if isY {
            ImgSafe(imgName, color: colorY)
        } else {
            ImgSafe(imgName, color: colorN)
        }
    }
}

#Preview {
    @Previewable @State var isY: Bool = true
    @Previewable @State var isN: Bool = false
    
    ImgShift(isY: isY)
    ImgShift(isY: isN)
}
