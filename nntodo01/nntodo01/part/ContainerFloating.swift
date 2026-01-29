//
//  ContainerPopup.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct ContainerFloating<C: View, B: View>: View {
    // init
    private let content: C
    private let label: B
    private let alignment: HorizontalAlignment
    
    init(
        alignment: HorizontalAlignment = .trailing,
        @ViewBuilder content: () -> C,
        @ViewBuilder label: () -> B,
    ) {
        self.alignment = alignment
        self.content = content()
        self.label = label()
    }
    
    var body: some View {
        ZStack {
            content
            VStack {
                Spacer()
                HStack {
                    label
                }
            }
        }
    }
}
