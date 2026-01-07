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
            if isChecked {
                if let uiImg = UIImage(named: activatedImgName) {
                    Image(uiImage: uiImg)
                } else {
                    Circle()
                        .fill(Color.cyan)
                }
            } else {
                if let uiImg = UIImage(named: activatedImgName) {
                    Image(uiImage: uiImg)
                } else {
                    Circle()
                        .stroke(Color.gray, lineWidth: 3)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isChecked: Bool = false
    
    BtnCheckImg($isChecked)
}
