//
//  ItemToday.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ItemToday: View {
    // init
    private let title: String
    @State private var list: [Work]
    
    init(_ title: String, list: [Work] = []) {
        self.title = title
        self._list = State(initialValue: list)
    }
    
    @State private var isOpend: Bool = true
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange.opacity(0.2))
                ImgShift(isY: $isOpend)
                    .frame(width: 20, height: 20)
                    .background(Color.orange.opacity(0.2))
                Spacer()
            }
            Divider()
            Group {
                if isOpend {
                    if list.isEmpty {
                        Text("\(title)의 할 일을 추가하세요.")
                            .font(.system(size: 15, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.gray.opacity(0.2))
                    } else {
                        ForEach(list, id: \.self) { work in
                            ItemTodo(work) { key, value in
                                // update
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 0)
    }
}

#Preview {
    ItemToday("Title")
}
