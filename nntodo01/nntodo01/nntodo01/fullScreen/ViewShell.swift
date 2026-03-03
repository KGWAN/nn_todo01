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
            ViewToday()
                .tag(1)
            ViewMain()
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
