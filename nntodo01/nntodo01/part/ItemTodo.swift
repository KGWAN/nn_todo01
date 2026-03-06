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
    }
    
    @State private var title: String
    @State private var isDone: Bool
    @State private var isMarked: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            // 완료 여부 체크 버튼
            BtnCheckImg(
                "btnDone",
                colorY: .blue,
                isChecked: $isDone)
                .frame(width: 25, height: 25)
                .buttonStyle(.borderless)
            // 이름
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            // 즐겨찾기 여부 체크 버튼
            BtnCheckImg(
                "btnStar",
                colorY: .yellow,
                isChecked: $isMarked
            )
            .frame(width: 25, height: 25)
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: 40)
        .border(.gray)
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
