//
//  ViewShell.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewShell: View {
    @State private var tabShowing = 1
    
    var body: some View {
        TabView(selection: $tabShowing) {
            Text("ViewCalendar, todo by calendar")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red.opacity(0.2))
                .tag(0)
            Text("ViewToday, todo by today, first")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.orange.opacity(0.2))
                .tag(1)
            Text("ViewMain, todo by kategories")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow.opacity(0.2))
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .ignoresSafeArea()
    }
}

#Preview {
    ViewShell()
}
