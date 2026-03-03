//
//  ImgSafe.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ImgSafe: View {
    private let nameImg: String
    private let color: Color
    
    init(_ nameImg: String = "", color: Color = .black) {
        self.nameImg = nameImg
        self.color = color
    }
    
    var body: some View {
        if !(nameImg.isEmpty),
           let uiImg = UIImage(named: nameImg) {
            Image(uiImage: uiImg)
                .resizable()
                .scaledToFit()
                .foregroundStyle(color)
                
        } else {
            Circle()
                .fill(.gray)
        }
    }
}

#Preview {
    ImgSafe("iconTempNomal")
    ImgSafe()
}
