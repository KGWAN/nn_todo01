//
//  ItemInventory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ItemInventory: View {
    private let imgName: String
    private let title: String
    
    init(_ title: String, imgName: String = "no_img") {
        self.title = title
        self.imgName = imgName
    }
    
    var body: some View {
        HStack {
            ImgSafe(imgName)
                .frame(width: 35, height: 35)
            Text(title)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ItemInventory("title")
}
