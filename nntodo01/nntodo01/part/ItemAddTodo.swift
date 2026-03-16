//
//  ItemTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ItemAddTodo: View {
    // init
    init(
        _ inf: Work,
        onUpdate: @escaping (String, Any) -> Void
    ) {
        self.title = inf.title ?? ""
        self.isDone = inf.isDone
        self.isMarked = inf.isMarked
        self.onUpdate = onUpdate
    }
    // in value
    private let title: String
    private let isDone: Bool
    private let isMarked: Bool
    private let onUpdate: (String, Any) -> Void
    
    
//    @State private var stateSubwork: State
    
    var body: some View {
        HStack(alignment: .center) {
            ImgShift(
                "btnDone",
                colorY: .blue,
                isY: isDone
            )
            .frame(width: 25, height: 25)
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            ImgShift(
                "btnStar",
                colorY: .yellow,
                isY: isMarked
            )
            .frame(width: 25, height: 25)
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
    let item = ServiceWork().getNew("todo")
    
    ItemAddTodo(item) { key, value in
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
