//
//  ItemInventory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ItemInventory: View {
    // init
    private let imgName: String
    private let title: String
    private let cnt: Int
    
    init(_ title: String, imgName: String = "no_img", cnt: Int = 0) {
        self.title = title
        self.imgName = imgName
        self.cnt = cnt // 작업 개수
    }
    
    
    var body: some View {
        HStack {
            ImgSafe(imgName)
                .frame(width: 35, height: 35)
            Text(title)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            if cnt > 0 {
                Text(String(cnt))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ItemInventory("title")
}
