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
                        // 뒤로가기 버튼
                        BtnImg("") {
                            onDismiss()
                            dismiss()
                        }
                        .frame(width: 35, height: 35)
                        // 제목
                        Text(title)
                        // 기타 메뉴
                        
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    contentTrailing()
                }
            }
    }
}

