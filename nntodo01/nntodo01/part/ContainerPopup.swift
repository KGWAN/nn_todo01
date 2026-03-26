//
//  ContainerPopup.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct ContainerPopup<Content: View>: View {
    // in
    private let alignment: Alignment
    private let opacity: Double
    @ViewBuilder private let content: Content
    // init
    init(
        _ alignment: Alignment = .center,
        opacity: Double = 0.4,
        content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.opacity = opacity
        self.content = content()
    }
    // environment
    @EnvironmentObject private var manager: ManagerPopup
    
    
    var body: some View {
        ZStack(alignment: alignment) {
            ViewDim(opacity: opacity)
            content
        }
    }
}
