//
//  ItemTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ItemSubwork: View {
    let onUpdate: (String, Any) -> Void
    
    init(
        _ inf: Subwork,
        onUpdate: @escaping (String, Any) -> Void
    ) {
        self.title = inf.title ?? ""
        self.isDone = inf.isDone
        self.onUpdate = onUpdate
    }
    
    @State private var title: String
    @State private var isDone: Bool
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            BtnCheckImg($isDone)
                .frame(width: 25, height: 25)
                .buttonStyle(.borderless)
                .padding(.vertical, 10)
            VStack {
                HStack {
                    TextFieldTitle(placeholder: "서브 작업 이름 바꾸기", text: $title)
                        .font(Font.system(size: 20, weight: .light))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // 삭제 버튼
//                    BtnImg("") {
//                        
//                    }
//                    .frame(width: 20, height: 20)
//                    .buttonStyle(.borderless)
                }
                Divider()
                    .padding(.horizontal, 10)
            }
        }
        .background(Color.white)
        .onChange(of: isDone) { _, new in
            onUpdate("isDone", new)
        }
    }
}

#Preview {
    let item = ServiceSubwork().getNew("todo's subwork")
    
    ItemSubwork(item) { key, value in
        NnLogger.log("Todo(\(item.title ?? "")) was changed. (key:\(key), value:\(value))", level: .debug)
        switch key {
        case "isDone":
            item.isDone = value as! Bool
        default:
            NnLogger.log("\(key) was not existed.")
        }
    }
}
