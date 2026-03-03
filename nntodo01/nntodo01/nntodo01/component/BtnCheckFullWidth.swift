//
//  BtnCheckFullWidth.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/27/26.
//

import SwiftUI

struct BtnCheckFullWidth: View {
    // init
    @Binding var isChecked: Bool
    let strOn: String
    let strOff: String
    
    init(
        _ isChecked: Binding<Bool>,
        strOn: String,
        strOff: String
    ) {
        self._isChecked = isChecked
        self.strOn = strOn
        self.strOff = strOff
    }
    // state
    
    
    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            HStack {
                ImgShift(isY: $isChecked)
                .frame(width: 20, height: 20)
                Text(isChecked ? strOn : strOff)
                    .font(Font.system(size: 18, weight: .light))
                    .padding(.leading, 10)
                    .foregroundColor(isChecked ? Color.blue : Color.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

#Preview {
    @Previewable @State var isChecked: Bool = false
    
    BtnCheckFullWidth($isChecked, strOn: "title(on)", strOff: "title(off)")
}
