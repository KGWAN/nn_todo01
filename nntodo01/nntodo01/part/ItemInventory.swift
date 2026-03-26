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
        self.cnt = cnt // 미완료 작업 개수
    }
    
    
    var body: some View {
        HStack {
            ImgSafe(nameImg, color: color)
                .frame(width: 25, height: 25)
                .padding(2.5)
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.vertical, 3)
            if cnt > 0 {
                Text(String(cnt))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.white)
                    .frame(width: 20, height: 20)
                    .background(.red.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 10)
        .background {
            Color.white
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
        }
        .padding(2.5)
    }
}

#Preview {
    ItemInventory("title", nameImg: "iconTempNomal")
}
