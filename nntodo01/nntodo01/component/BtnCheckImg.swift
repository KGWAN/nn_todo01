//
//  BtnCheck.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct BtnCheckImg: View {
    // init
    let activatedImgName: String
    let deactivatedImgName: String
    @Binding var isChecked: Bool
    
    init(
        _ isChecked: Binding<Bool>,
        activatedImgName: String = "no_img",
        deactivatedImgName: String = "no_img"
    ) {
        self.activatedImgName = activatedImgName
        self.deactivatedImgName = deactivatedImgName
        self._isChecked = isChecked
    }
    
    
    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            ImgShift(
                $isChecked,
                imgY: activatedImgName,
                imgN: deactivatedImgName
            )
        }
    }
}

#Preview {
    @Previewable @State var isChecked: Bool = false
    
    BtnCheckImg($isChecked)
}
