//
//  BtnCheck.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct BtnCheckText: View {
    // in value
    let title: String
    @Binding var isChecked: Bool
    // init
    init(_ title: String, isChecked: Binding<Bool>) {
        self.title = title
        self._isChecked = isChecked
    }
    
    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            Text(title)
                .foregroundStyle(isChecked ? .black : .gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isChecked ? .white : .clear)
        }
    }
}

#Preview {
    @Previewable @State var isChecked: Bool = false
    
    BtnCheckText("title", isChecked: $isChecked)
        .border(.red)
}
