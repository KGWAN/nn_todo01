//
//  BtnCheck.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct BtnImg: View {
    //init
    private let imgName: String
    private let action: () -> Void
    
    init(_ imgName: String = "no_img",
         action: @escaping () -> Void) {
        self.imgName = imgName
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            if let uiImg = UIImage(named: imgName) {
                Image(uiImage: uiImg)
            } else {
                Circle()
                    .fill(Color.cyan)
            }
        }
    }
}

#Preview {
    BtnImg() {
        NnLogger.log("BtnImg(preview) was tapped.", level: .debug)
    }
}
