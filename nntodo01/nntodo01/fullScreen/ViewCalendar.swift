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
    @State private var year: Int = Calendar.nn.getYear(Date())
    @State private var idRefresh: UUID = UUID()
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                BtnImg("left", color: .cyan) {
                    year -= 1
                    reload()
                }
                .frame(width: 25, height: 25)
                Text("\(String(year))년")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.vertical, 5)
                BtnImg("right", color: .cyan) {
                    year += 1
                    reload()
                }
                .frame(width: 25, height: 25)
            }
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
            ZStack {
                ViewYear(year)
                    .opacity(idxSelectedTab == 0 ? 1 : 0)
                ViewMonth(year: year)
                    .opacity(idxSelectedTab == 1 ? 1 : 0)
                ViewWeek(year: year)
                    .opacity(idxSelectedTab == 2 ? 1 : 0)
                ViewDay(year: year)
                    .opacity(idxSelectedTab == 3 ? 1 : 0)
            }
            .id(idRefresh)
//            Group {
//                switch idxSelectedTab {
//                case 0: ViewYear()
//                case 1: ViewMonth()
//                case 2: ViewWeek()
//                case 3: ViewDay()
//                default: EmptyView()
//                }
//            }
        }
    }
    
    
    // func
    private func reload() {
        idRefresh = UUID()
    }
}

#Preview {
    ViewCalendar()
}
