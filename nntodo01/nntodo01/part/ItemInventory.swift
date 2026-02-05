//
//  ItemInventory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ItemInventory: View {
    // init
    private let nameImg: String
    private let title: String
    private let color: Color
    private let cnt: Int
    
    init(_ title: String, nameImg: String = "", color: Color = .black, cnt: Int = 0) {
        self.title = title
        self.nameImg = nameImg
        self.color = color
        self.cnt = cnt // 작업 개수
    }
    
    
    var body: some View {
        HStack {
            Group {
                if !nameImg.isEmpty,
                   let img = UIImage(named: nameImg) {
                    Image(uiImage: img)
                        .resizable()
                        .foregroundStyle(color)
                        .scaledToFit()
                } else {
                    Circle()
                        .fill(Color.cyan)
                }
            }
            .frame(width: 35, height: 35, alignment: .center)
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
    ItemInventory("title", nameImg: "iconTempNomal")
}
