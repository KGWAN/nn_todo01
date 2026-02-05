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
    private let action: () -> Void
    
    init(_ imgName: String = "",
         action: @escaping () -> Void) {
        self.imgName = imgName
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ImgSafe(imgName)
        }
    }
}

#Preview {
    BtnImg() {
        NnLogger.log("BtnImg(preview) was tapped.", level: .debug)
    }
}
