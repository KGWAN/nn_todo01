//
//  ImgShift.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ImgShift: View {
    // init
    let imgName: String
    let colorY: Color
    let colorN: Color
    @Binding var isY: Bool
    
    init(
        _ imgName: String = "noImg",
        colorY: Color = .cyan,
        colorN: Color = .gray,
        isY: Binding<Bool>,
    ) {
        self._isY = isY
        self.imgName = imgName
        self.colorY = colorY
        self.colorN = colorN
    }
    
    var body: some View {
        if isY {
            if let uiImg = UIImage(named: imgName) {
                Image(uiImage: uiImg)
                    .resizable()
                    .foregroundStyle(colorY)
                    .scaledToFit()
            } else {
                Circle()
                    .fill(colorY)
            }
        } else {
            if let uiImg = UIImage(named: imgName) {
                Image(uiImage: uiImg)
                    .resizable()
                    .foregroundStyle(colorN)
                    .scaledToFit()
            } else {
                Circle()
                    .stroke(colorN)
            }
        }
    }
}

#Preview {
    @Previewable @State var isY: Bool = true
    @Previewable @State var isN: Bool = false
    
    ImgShift(isY: $isY)
    ImgShift(isY: $isN)
}
