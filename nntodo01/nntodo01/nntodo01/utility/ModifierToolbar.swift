//
//  NnToolbarModifier.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ModifierToolbar<R: View>: ViewModifier {
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
                    HStack(spacing: 10){
                        // 뒤로가기 버튼
                        BtnImg("btnBack") {
                            onDismiss()
                            dismiss()
                        }
                        .frame(width: 40, height: 40, alignment: .center)
                        // 제목
                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.black)
                            .padding(.trailing, 10)
                        // 기타 메뉴
                    }
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    contentTrailing()
                }
            }
    }
}

