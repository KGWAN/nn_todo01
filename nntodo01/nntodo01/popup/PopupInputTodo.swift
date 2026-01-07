//
//  PopupInputTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct PopupInputTodo: View {
    //init
    @Binding var isPresented: Bool
    let onFinish: (Todo) -> Void
    // state
    @State private var canInput: Bool = false
    @State private var todoText: String = ""
    
    var body: some View {
        ContainerPopup(
            .bottom,
            isPresented: $isPresented,
            content: {
                HStack(alignment: .center, spacing: 10) {
                    BtnCheckImg(Binding(get: { false }, set: { _ in }))
                        .frame(width: 35, height: 35)
                        .disabled(true)
                    TextFieldTitle(placeholder: "작업추가", text: $todoText)
                        .frame(maxWidth: .infinity)
                    BtnActivationImg(
                        action: {
                            onFinish(create())
                            isPresented = false
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
    
    private func create() -> Todo {
        return ServiceTodo().create(todoText)
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
    
    PopupInputTodo(isPresented: $isShowing) { todo in
        NnLogger.log("(preview)Adding todo: \(todo)", level: .debug)
    }
}
