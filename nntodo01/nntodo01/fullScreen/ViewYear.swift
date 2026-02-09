//
//  ViewYear.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewYear: View {
    var body: some View {
        ScrollView {
            Group {
                Text("Yearly plan")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 5)
                Divider()
                    .frame(height: 1)
                    .background(.black)
                    
            }
            .padding(.horizontal, 10)
            // 월별 리스트
        }
    }
}

#Preview {
    ViewYear()
}
