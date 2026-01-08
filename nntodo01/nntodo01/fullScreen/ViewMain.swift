//
//  ViewMain.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/5/26.
//

import SwiftUI

struct ViewMain: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: ViewSearchTodo()
                    ) {
                        // 검색
                        ImgSafe("")
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.horizontal, 20)
                
                NavigationLink(
                    destination: ViewListTodo()
                ) {
                    ItemInventory("작업", imgName: "")
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ViewMain()
}
