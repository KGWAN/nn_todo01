//
//  ContainerPopup.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct ContainerPopup<Content: View>: View {
    // init
    private let alignment: Alignment
    private let opacity: Double
    @Binding private var isPresented: Bool
    @ViewBuilder private let content: Content
    
    init(
        _ alignment: Alignment = .center,
        opacity: Double = 0.4,
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.opacity = opacity
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: alignment) {
            ViewDim(isShowingPopup: $isPresented, opacity: opacity)
            content
        }
    }
}
