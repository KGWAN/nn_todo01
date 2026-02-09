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
        HStack(spacing: 10) {
            Button{
                withAnimation {
                        idxSelectedTab = 0
                    }
            } label: {
                Text("년")
                    .fontWeight(idxSelectedTab == 0 ? .bold : .regular)
            }
            Button{
                withAnimation {
                        idxSelectedTab = 1
                    }
            } label: {
                Text("월")
                    .fontWeight(idxSelectedTab == 1 ? .bold : .regular)
            }
            Button{
                withAnimation {
                        idxSelectedTab = 2
                    }
            } label: {
                Text("주")
                    .fontWeight(idxSelectedTab == 2 ? .bold : .regular)
            }
            Button{
                withAnimation {
                        idxSelectedTab = 3
                    }
            } label: {
                Text("일")
                    .fontWeight(idxSelectedTab == 3 ? .bold : .regular)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        
        TabView(selection: $idxSelectedTab) {
            Text("ViewYear")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red.opacity(0.2))
                .tag(0)
            Text("ViewMonth")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.orange.opacity(0.2))
                .tag(1)
            Text("ViewWeek")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.yellow.opacity(0.2))
                .tag(2)
            Text("ViewDay")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.green.opacity(0.2))
                .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    ViewCalendar()
}
