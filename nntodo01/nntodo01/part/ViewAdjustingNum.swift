//
//  ItemToday.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewAdjustingNum: View {
    // in value
    @Binding private var target: Int
    private let limit: Int
    private let title: String
    // init
    init(_ target: Binding<Int>, limit: Int, labelText: String = "") {
        self._target = target
        self.limit = limit
        self.title = labelText
    }

    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .frame(minWidth: 50)
                .padding(.horizontal, 30)
            HStack(alignment: .center, spacing: 10) {
                BtnImg("left", color: target > 1 ? .cyan : .gray) {
                    if target > 1 {
                        target -= 1
                    }
                }
                .frame(width: 25, height: 25)
                .padding(.horizontal, 5)
                .disabled(target <= 1)
                Text("\(String(target))")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                BtnImg("right", color: target < limit ? .cyan : .gray) {
                    if target < limit {
                        target += 1
                    }
                }
                .frame(width: 25, height: 25)
                .padding(.horizontal, 5)
                .disabled(target >= limit)
            }
            .frame(maxWidth: .infinity)
            .background(.white)
        }
        .padding(.bottom, 2)
        .background(.gray.opacity(0.4))
    }
}

#Preview {
    @Previewable @State var num: Int = 1
    
    ViewAdjustingNum($num, limit: 12, labelText: "label")
}
