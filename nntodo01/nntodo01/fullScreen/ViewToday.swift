//
//  ViewToday.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewToday: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 오늘
                Text("ItemToday")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.2))
                // 이번달
                Text("ItemMonth")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.2))
                // 올해
                Text("ItemYear")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.2))
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    ViewToday()
}
