//
//  ImgSafe.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ImgSafe: View {
    private let imgName: String
    
    init(_ imgName: String = "no_img") {
        self.imgName = imgName
    }
    
    var body: some View {
        if let uiImg = UIImage(named: imgName) {
            Image(uiImage: uiImg)
        } else {
            Circle()
                .fill(Color.cyan)
        }
    }
}

#Preview {
    ImgSafe()
}
