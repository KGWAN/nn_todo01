//
//  ViewDim.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct ViewDim: View {
    // in
    @State var opacity: Double = 0.4
    // init
    init(opacity: Double) {
        self.opacity = opacity
    }
    // environment
    @EnvironmentObject private var manager: ManagerPopup
    
    var body: some View {
        Color.black.opacity(opacity)
            .ignoresSafeArea()
            .onTapGesture {
                manager.hide()
            }
            .transition(.opacity)
            .contentShape(Rectangle())
    }
}

#Preview {
    ViewDim(opacity: 0.4)
        .environmentObject(ManagerPopup())
}
