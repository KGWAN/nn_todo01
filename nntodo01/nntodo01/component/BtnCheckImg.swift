//
//  BtnCheckImg.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct BtnCheckImg: View {
    // init
    let nameImg: String
    let colorY: Color
    let colorN: Color
    @Binding var isChecked: Bool
    
    init(
        _ nameImg: String = "noImg",
        colorY: Color = .cyan,
        colorN: Color = .gray,
        isChecked: Binding<Bool>
    ) {
        self._isChecked = isChecked
        self.nameImg = nameImg
        self.colorY = colorY
        self.colorN = colorN
    }
    
    
    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            ImgShift(
                nameImg,
                colorY: colorY,
                colorN: colorN,
                isY: $isChecked
            )
        }
    }
}

#Preview {
    @Previewable @State var isChecked: Bool = false
    
    BtnCheckImg(isChecked: $isChecked)
}
