//
//  BtnImg.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct BtnActivationImg: View {
    // init
    let action: () -> Void
    @Binding var isEnabled: Bool
    let activatedImgName: String
    let deactivatedImgName: String
    
    init (
        action: @escaping () -> Void,
        isEnabled: Binding<Bool>,
        activatedImgName: String = "no_img",
        deactivatedImgName: String = "no_img") {
        self.action = action
        self._isEnabled = isEnabled
        self.activatedImgName = activatedImgName
        self.deactivatedImgName = deactivatedImgName
        
    }
    
    var body: some View {
        Button {
            if isEnabled {
                action()
            }
        } label: {
            ImgShift(
                isY: $isEnabled
            )
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    @Previewable @State var isActive: Bool = true
    
    BtnActivationImg(
        action: {
            NnLogger.log("BtnActivationImg(Preview) was Tapped.", level: .debug)
        }, isEnabled: $isActive
    )
}
