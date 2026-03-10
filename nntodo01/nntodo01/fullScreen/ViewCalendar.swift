//
//  ViewCalendar.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewCalendar: View {
    // state
    @State private var idxSelectedTab = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button{
                    withAnimation {
                        idxSelectedTab = 0
                    }
                } label: {
                    Text("Year")
                        .fontWeight(idxSelectedTab == 0 ? .bold : .regular)
                        .foregroundStyle(idxSelectedTab == 0 ? .cyan : .gray)
                }
                .frame(maxWidth: .infinity)
                .background(idxSelectedTab == 0 ? .white : .clear)
                
                Button{
                    withAnimation {
                        idxSelectedTab = 1
                    }
                } label: {
                    Text("Month")
                        .fontWeight(idxSelectedTab == 1 ? .bold : .regular)
                        .foregroundStyle(idxSelectedTab == 1 ? .cyan : .gray)
                }
                .frame(maxWidth: .infinity)
                .background(idxSelectedTab == 1 ? .white : .clear)
                
                Button{
                    withAnimation {
                        idxSelectedTab = 2
                    }
                } label: {
                    Text("Week")
                        .fontWeight(idxSelectedTab == 2 ? .bold : .regular)
                        .foregroundStyle(idxSelectedTab == 2 ? .cyan : .gray)
                }
                .frame(maxWidth: .infinity)
                .background(idxSelectedTab == 2 ? .white : .clear)
                
                Button{
                    withAnimation {
                        idxSelectedTab = 3
                    }
                } label: {
                    Text("Day")
                        .fontWeight(idxSelectedTab == 3 ? .bold : .regular)
                        .foregroundStyle(idxSelectedTab == 3 ? .cyan : .gray)
                }
                .frame(maxWidth: .infinity)
                .background(idxSelectedTab == 3 ? .white : .clear)
            }
            .padding(.top, 5)
            .background(.gray.opacity(0.3))
            
            // 콘텐츠 영역
            Group {
                switch idxSelectedTab {
                case 0: ViewYear()
                case 1: ViewMonth()
                case 2: ViewWeek()
                case 3: ViewDay()
                default: EmptyView()
                }
            }
        }
    }
}

#Preview {
    ViewCalendar()
}
