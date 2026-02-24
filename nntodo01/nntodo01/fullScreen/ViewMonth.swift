//
//  ViewMonth.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewMonth: View {
    
    var body: some View {
        ScrollView {
            ForEach(0..<12, id: \.self) { i in
                // header
                Group {
                    Text("\(i + 1) 월")
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                        .frame(height: 0.5)
                        .background(.black)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 10)
                // 월별 리스트
                
            }
        }
    }
}

#Preview {
    ViewMonth()
}
