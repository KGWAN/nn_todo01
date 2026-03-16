//
//  ViewShell.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewShell: View {
    // state
    @State private var tabShowing = 1
//    @State private var idRefresh: UUID = UUID()
    
    var body: some View {
        ZStack {
            TabView(selection: $tabShowing) {
                ViewCalendar()
                    .tag(0)
                ViewToday()
                    .tag(1)
                ViewMain()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ViewShell()
}
