//
//  TextEditerTitle.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct TextFieldTitle: View {
    // init
    let placeholder: String
    @Binding var text: String
    let color: Color?
    
    init(placeholder: String, text: Binding<String>, color: Color? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.color = color
    }
    // value
    
    // environment
    
    // state
    
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
            if let color {
                Divider()
                    .frame(height: 1)
                    .background(color)
            }
        }
        .padding(10)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    TextFieldTitle(placeholder: "placeholder.", text: $text, color: .blue)
}
