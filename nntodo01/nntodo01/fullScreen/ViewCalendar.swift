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
    // constant
    private let listTab: [TypePlan] = TypePlan.allCases
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // year
                viewSelectingYear
                    .padding(.top, 5)
                // tab
                HStack(spacing: 0) {
                    ForEach(listTab.indices, id: \.self) { idx in
                        Button{
                            withAnimation {
                                idxSelectedTab = idx
                            }
                        } label: {
                            Text("\(listTab[idx].name)")
                                .fontWeight(idxSelectedTab == idx ? .bold : .regular)
                                .foregroundStyle(idxSelectedTab == idx ? .cyan : .gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background{
                                    if idxSelectedTab == idx {
                                        Color.white
                                            .cornerRadius(15)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                                            }
                                            .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                                    } else {
                                        Color.clear
                                    }
                                }
                        }
                    }
                }
                .frame(height: 30)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                .padding(2.5)
                // 콘텐츠 영역
                ZStack {
                    ViewYear(year)
                        .background(.clear)
                        .opacity(idxSelectedTab == 0 ? 1 : 0)
                    ViewMonth(year: year)
                        .opacity(idxSelectedTab == 1 ? 1 : 0)
                    ViewWeek(year: year)
                        .opacity(idxSelectedTab == 2 ? 1 : 0)
                    ViewDay(year: year)
                        .opacity(idxSelectedTab == 3 ? 1 : 0)
                }
            }
            .id(idRefresh)
            .padding(.horizontal, 20)
            .background(.gray.opacity(0.2))
        }
    }
    
    
    // ViewBuilder
    @ViewBuilder
    private var viewSelectingYear: some View {
        HStack(spacing: 10) {
            BtnImg("left", color: .cyan) {
                year -= 1
                reload()
            }
            Text("\(String(year))년")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                .padding(2.5)
            BtnImg("right", color: .cyan) {
                year += 1
                reload()
            }
        }
        .frame(height: 30)
    }
    
    
    // func
    private func reload() {
        idRefresh = UUID()
    }
}

#Preview {
    ViewCalendar()
}
