//
//  ContainerPopup.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct ContainerBtnFloating<C: View, B: View>: View {
    // init
    private let content: C
    private let labelBtn: B
    private let action: () -> Void
    
    init(
        @ViewBuilder content: () -> C,
        @ViewBuilder labelBtn: () -> B,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.labelBtn = labelBtn()
        self.action = action
    }
    
    var body: some View {
        ZStack {
            content
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        action()
                    } label: {
                        labelBtn
                    }

                }
            }
        }
    }
}
