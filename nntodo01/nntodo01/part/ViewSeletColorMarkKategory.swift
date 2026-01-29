//
//  ViewSeletColorMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import SwiftUI

struct ViewSeletColorMarkKategory: View {
    @Binding var selectedColor : ColorMarkKategory
    
    // constant
    private let thickness : CGFloat = 12
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 30) {
                ForEach(ColorMarkKategory.allCases, id: \.id) { type in
                    Button {
                        selectedColor = type
                    } label: {
                        Circle()
                            .fill(selectedColor == type ? Color.white : type.color)
                            .stroke(type.color, lineWidth: thickness)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .padding(.horizontal, thickness/2 + 1)
            .padding(.vertical, thickness/2 + 1)
        }
    }
}

#Preview {
    @Previewable @State var selectedColor : ColorMarkKategory = ColorMarkKategory.allCases[0]
    
    Group {
        ViewSeletColorMarkKategory(selectedColor: $selectedColor)
    }
    .frame(maxWidth: .infinity, maxHeight: 40)
    .background(Color.yellow)
}
