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
    // value
    
    // environment
    
    // state
    
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.title)
            .padding(10)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    TextFieldTitle(placeholder: "placeholder.", text: $text)
}
