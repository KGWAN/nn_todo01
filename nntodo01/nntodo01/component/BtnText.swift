//
//  btnText.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/5/26.
//

import SwiftUI

struct BtnText: View {
    // init
    private let text: String
    private let action: () -> Void
    
    init (_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.black)
        }
    }
}

#Preview {
    BtnText(
        "Title",
        action: {
            NnLogger.log("BtnText(Preview) was Tapped.", level: .debug)
        }
    )
}
