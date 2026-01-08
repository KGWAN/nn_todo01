//
//  ImgShift.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ImgShift: View {
    // init
    let imgY: String
    let imgN: String
    @Binding var isY: Bool
    
    init(
        _ isY: Binding<Bool>,
        imgY: String = "no_img",
        imgN: String = "no_img"
    ) {
        self.imgY = imgY
        self.imgN = imgN
        self._isY = isY
    }
    
    var body: some View {
        if isY {
            if let uiImg = UIImage(named: imgY) {
                Image(uiImage: uiImg)
            } else {
                Rectangle()
                    .fill(Color.cyan)
            }
        } else {
            if let uiImg = UIImage(named: imgN) {
                Image(uiImage: uiImg)
            } else {
                Rectangle()
                    .stroke(Color.gray, lineWidth: 3)
            }
        }
    }
}

#Preview {
    @Previewable @State var isY: Bool = true
    @Previewable @State var isN: Bool = false
    
    ImgShift($isY)
    ImgShift($isN)
}
