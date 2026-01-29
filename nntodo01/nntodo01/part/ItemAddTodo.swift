//
//  ItemTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ItemAddTodo: View {
    // init
    let onUpdate: (String, Any) -> Void
    
    init(
        _ inf: Work,
        onUpdate: @escaping (String, Any) -> Void
    ) {
        self.title = inf.title ?? ""
        self.isDone = inf.isDone
        self.onUpdate = onUpdate
    }
    // state
    @State private var title: String
    @State private var isDone: Bool
//    @State private var stateSubwork: State
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            BtnCheckImg($isDone)
                .frame(width: 35, height: 35)
                .buttonStyle(.borderless)
            VStack {
                Text(title)
                    .font(.title)
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
            }
            BtnImg("", action: {
                onUpdate("isToday", true)
            })
            .frame(width: 35, height: 35)
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background(Color.white)
        .onChange(of: isDone) { _, new in
            onUpdate("isDone", new)
        }
    }
}

#Preview {
    let item = ServiceWork().getNewWork("todo")
    
    ItemAddTodo(item) { key, value in
        NnLogger.log("Todo(\(item.title ?? "")) was changed. (key:\(key), value:\(value))", level: .debug)
        
        switch key {
        case "isDone":
            item.isDone = value as! Bool
        case "isMarked":
            item.isMarked = value as! Bool
        case "isToday":
            item.isToday = value as! Bool
        default:
            NnLogger.log("\(key) was not existed.")
        }
    }
}
