//
//  ViewDetailTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ViewDetailTodo: View {
    // init
    @State var item: Todo
    let onUpdate: (Todo) -> Void
    let onDelete: (Todo) -> Void
    
    init(_ item: Todo, onUpdate: @escaping (Todo) -> Void, onDelete: @escaping (Todo) -> Void) {
        self.item = item
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        
        self._todoText = State(initialValue: item.title)
        self._isDone = State(initialValue: item.isDone)
        self._isMarked = State(initialValue: false)
    }
    
    // state
    @State private var todoText: String = ""
    @State private var isDone: Bool
    @State private var isMarked: Bool
    // environment
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("todo detail")
                Spacer()
                HStack {
                    Spacer()
                    BtnImg("") {
                        onDelete(item)
                        dismiss()
                    }
                    .frame(width: 35, height: 35)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        BtnImg("") {
                            onUpdate(item)
                            dismiss()
                        }
                        .frame(width: 35, height: 35)
                        TextFieldTitle(placeholder: "작업이름을 바꾸어 보세요.", text: $todoText)
                            .frame(maxWidth: .infinity)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        BtnCheckImg($isDone)
                            .frame(width: 35, height: 35)
                        
                        BtnCheckImg($isMarked)
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
        
    }
}

#Preview {
    let item = Todo("Hello, World!", isDone: true)
    
    ViewDetailTodo(item) { new in
        NnLogger.log("Todo was changed: (\(item) -> \(new)", level: .debug)
    } onDelete: { i in
        NnLogger.log("Todo was deleted: (\(i)", level: .debug)
    }
}
