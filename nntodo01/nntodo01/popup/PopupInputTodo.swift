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
    let templete: Templete
    let kategorie: Kategory?
    let onFinish: (Result) -> Void
    
    init(
        isPresented: Binding<Bool>,
        templete: Templete,
        kategorie: Kategory? = nil,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.templete = templete
        self.kategorie = kategorie
        self.onFinish = onFinish
    }
    // state
    @State private var canInput: Bool = false
    @State private var text: String = ""
    
    var body: some View {
        ContainerPopup(
            .bottom,
            isPresented: $isPresented,
            content: {
                HStack(alignment: .center, spacing: 10) {
                    BtnCheckImg(Binding(get: { false }, set: { _ in }))
                        .frame(width: 35, height: 35)
                        .disabled(true)
                    TextFieldTitle(placeholder: "작업추가", text: $text)
                        .frame(maxWidth: .infinity)
                    Button {
                        if canInput {
                            onFinish(create(text))
                            isPresented = false
                        }
                    } label: {
                        ImgSafe("btnInputTodo", color: Color.white)
                    }
                    .frame(width: 40, height: 40)
                    .background(canInput ? Color.cyan: Color.gray)
                    .cornerRadius(10)
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .onChange(of: text) { _, _ in
                    checkCanInput()
                }
                .background(Color.white)
            }
        )
    }
    
    
    // MARK: func
    private func checkCanInput() {
        canInput = !text.isEmpty
    }
    
    private func create(_ title: String) -> Result {
        return ServiceWork().create(
            title,
            isMarked: templete == .marked,
            isToday: templete == .today,
            kategory: kategorie
        )
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
//    let templete: Templete = .nomal
    let templete: Templete = .today
//    let kategory: Kategory? = nil
    let kategory: Kategory = ServiceKategory().getNew("kate_preview")
    
    PopupInputTodo(
        isPresented: $isShowing,
        templete: templete,
        kategorie: kategory
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
}
