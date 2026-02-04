//
//  ViewSeletColorMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import SwiftUI

struct ViewSelectColorMarkKategory: View {
    @Binding var selectedOne : ColorMarkKategory
    
    // constant
    private let radius : CGFloat = 20
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(ColorMarkKategory.allCases, id: \.id) { type in
                    ZStack {
                        Button {
                            selectedOne = type
                        } label: {
                            Circle()
                                .fill(type.color)
                                .frame(width: radius*2, height: radius*2, alignment: .center)
                        }
                        if selectedOne == type {
                            Circle()
                                .fill(Color.white)
                                .frame(width: radius*0.7, alignment: .center)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedColor : ColorMarkKategory = ColorMarkKategory.allCases[0]
    
    Group {
        ViewSelectColorMarkKategory(selectedOne: $selectedColor)
    }
    .frame(maxWidth: .infinity, maxHeight: 40)
    .background(Color.yellow)
}
