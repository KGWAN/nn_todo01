//
//  ItemTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ItemTodo: View {
    let onUpdate: (String, Any) -> Void
    
    init(
        _ inf: Work,
        onUpdate: @escaping (String, Any) -> Void
    ) {
        self.title = inf.title ?? ""
        self.isDone = inf.isDone
        self.isMarked = inf.isMarked
        self.onUpdate = onUpdate
//        self.stateSubwork = "\(inf.subwork.count))"
    }
    
    @State private var title: String
    @State private var isDone: Bool
    @State private var isMarked: Bool
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
//                if !stateSubwork.isEmpty {
//                    Text(stateSubwork)
//                        .font(.callout)
//                        .foregroundStyle(Color.black)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.leading, 10)
//                }
            }
            BtnCheckImg($isMarked)
                .frame(width: 35, height: 35)
                .buttonStyle(.borderless)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background(Color.white)
        .onChange(of: isDone) { _, new in
            onUpdate("isDone", new)
        }
        .onChange(of: isMarked) { _, new in
            onUpdate("isMarked", new)
        }
    }
}

#Preview {
    let item = ServiceWork().getNew("todo")
    
    ItemTodo(item) { key, value in
        NnLogger.log("Todo(\(item.title ?? "")) was changed. (key:\(key), value:\(value))", level: .debug)
        
        switch key {
        case "isDone":
            item.isDone = value as! Bool
        case "isMarked":
            item.isMarked = value as! Bool
        default:
            NnLogger.log("\(key) was not existed.")
        }
    }
}
