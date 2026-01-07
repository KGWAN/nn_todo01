//
//  ItemTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ItemTodo: View {
    @State var item: Todo
    let onUpdate: (Todo) -> Void
    
    init(_ item: Todo, onUpdate: @escaping (Todo) -> Void) {
        self.item = item
        self.isDone = item.isDone
        self.isMarked = false
        self.onUpdate = onUpdate
    }
    
    //state
    @State private var isDone: Bool
    @State private var isMarked: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            BtnCheckImg($isDone)
                .frame(width: 35, height: 35)
            Text(item.title)
                .font(.title)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            BtnCheckImg($isMarked)
                .frame(width: 35, height: 35)
                .hidden()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background(Color.white)
        .onChange(of: isDone) { o, n in
            item.isDone = n
            onUpdate(item)
        }
    }
}

#Preview {
    let item = Todo("Hello, World!")
    let doneItem = Todo("Hello, World!", isDone: true)
    
    ItemTodo(item) { new in
        NnLogger.log("Todo was changed: (\(item) -> \(new)", level: .debug)
    }
    ItemTodo(doneItem) { new in
        NnLogger.log("Todo was changed: (\(item) -> \(new)", level: .debug)
    }
}
