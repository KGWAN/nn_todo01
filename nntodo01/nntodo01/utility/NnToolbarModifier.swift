//
//  NnToolbarModifier.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct NnToolbarModifier<R: View>: ViewModifier {
    // init
    let title: String
    let onDismiss: (() -> Void)
    @ViewBuilder var contentTrailing: (() -> R)
    
    // environment
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        BtnImg("") {
                            onDismiss()
                            dismiss()
                        }
                        .frame(width: 35, height: 35)
                        
                        Text(title)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    contentTrailing()
                }
            }
    }
}

