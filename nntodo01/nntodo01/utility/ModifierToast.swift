//
//  ViewToast.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/26/26.
//

import SwiftUI

struct ModifierToast: ViewModifier {
    let msg: String
    @Binding var isPresented: Bool
    
    init(_ msg: String, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.msg = msg
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Spacer()
                    Text(msg)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.cyan.opacity(0.7))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
                .zIndex(1)
            }
        }
        .onChange(of: isPresented) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isPresented = false
                    }
                }
            }
        }
    }
}
