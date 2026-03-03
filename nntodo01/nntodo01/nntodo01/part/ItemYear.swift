//
//  ItemYear.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ItemYear: View {
    // init
    private let title: String
    @State private var list: [Work] = []
    
    init(_ title: String = "month") {
        self.title = title
    }
    
    var body: some View {
        Group {
            Group {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 0)
                Divider()
                    .background(.gray)
            }
            
            Group {
                if list.isEmpty {
                    Text("이 달은 할 일이 없습니다.")
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
            
            .padding(.vertical, 5)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ItemYear("1 Jaunary")
}
