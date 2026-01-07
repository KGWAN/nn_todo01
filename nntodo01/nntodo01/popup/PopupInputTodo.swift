//
//  PopupInputTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct PopupInputTodo: View {
    @Binding var isPresented: Bool
    
    @State private var todoText: String = ""
    @State private var canInput: Bool = false
    
    var body: some View {
        ContainerPopup(
            .bottom,
            isPresented: $isPresented,
            content: {
                HStack(alignment: .center, spacing: 10) {
                    BtnCheck()
                        .frame(width: 35, height: 35)
                        .disabled(true)
                    TextFieldTitle(placeholder: "작업추가", text: $todoText)
                        .frame(maxWidth: .infinity)
                    BtnActivationImg(
                        action: {
                            NnLogger.log("Adding todo: \(todoText)", level: .debug)
                        }, isEnabled: $canInput
                    )
                    .frame(width: 35, height: 35)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .onChange(of: todoText) { o, n in
                    canInput = !todoText.isEmpty
                }
                .background(Color.white)
            }
        )
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
    
    PopupInputTodo(isPresented: $isShowing)
}
