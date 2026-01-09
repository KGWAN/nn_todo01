//
//  ViewDim.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct ViewDim: View {
    @Binding var isShowingPopup: Bool
    @State var opacity: Double = 0.4
    
    var body: some View {
        Color.black.opacity(opacity)
            .ignoresSafeArea()
            .onTapGesture {
                isShowingPopup = false
            }
            .transition(.opacity)
            .animation(.easeOut, value: isShowingPopup)
            .edgesIgnoringSafeArea(.all)
            .contentShape(Rectangle())
    }
}

#Preview {
    @Previewable @State var isShowingPopup: Bool = false
    
    ViewDim(isShowingPopup: $isShowingPopup)
}
