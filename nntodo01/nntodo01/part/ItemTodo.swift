//
//  ItemTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ItemTodo: View {
    // init --------------------
    // value
    private let title: String
    @State private var isDone: Bool
    @State private var isMarked: Bool
    private let depth: Int
    private let cntChild: Int
    private let isLocked: Bool
    private let kategory: Kategory?
    private let onUpdate: (String, Any) -> Void
    // func
    init(
        _ inf: Work,
        onUpdate: @escaping (String, Any) -> Void
    ) {
        self.title = inf.title ?? ""
        self.isDone = inf.isDone
        self.isMarked = inf.isMarked
        self.depth = Int(inf.depth)
        self.onUpdate = onUpdate
        self.cntChild = ((inf.children?.allObjects as? [Work])?.filter { $0.isDone == false } ?? []).count
        self.isLocked = inf.isLocked
        self.kategory = inf.kategory
    }
    // 기존의 할 일을 추가하는 경우: PopupSelectingTodo
    init(
        _ inf: Work
    ) {
        self.title = inf.title ?? ""
        self.isDone = inf.isDone
        self.isMarked = inf.isMarked
        self.depth = Int(inf.depth)
        self.onUpdate = {_, _ in }
        self.cntChild = ((inf.children?.allObjects as? [Work])?.filter { $0.isDone == false } ?? []).count
        self.isLocked = inf.isLocked
        self.kategory = inf.kategory
    }
    // -------------------------
    
    
    var body: some View {
        HStack(spacing: 5) {
            // 완료 여부 체크 버튼
            BtnCheckImg(
                "btnDone",
                colorY: .blue,
                isChecked: $isDone)
                .frame(width: 25, height: 25)
                .padding(2.5)
                .disabled(isLocked)
            // 이름
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.vertical, 3)
            // 잠김 여부
            ImgSafe("lock", color: .gray)
                .frame(width: 22.5, height: 22.5)
                .padding(2.5)
                .opacity(isLocked ? 1 : 0)
            // 층수
            Text("lv.\(depth)")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .frame(height: 20)
                .padding(.horizontal, 10)
                .background {
                    Color.gray
                        .cornerRadius(15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                }
                .padding(2.5)
                .opacity(depth == 0 ? 0 : 1)
            // 자식 수
            Text(String(cntChild))
                .frame(width: 20, height: 20)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white)
                .background {
                    Color.red
                        .opacity(0.8)
                        .cornerRadius(15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                }
                .padding(2.5)
                .opacity(cntChild == 0 ? 0 : 1)
            // 즐겨찾기 여부 체크 버튼
            BtnCheckImg(
                "btnStar",
                colorY: .yellow,
                isChecked: $isMarked
            )
            .frame(width: 25, height: 25)
            .padding(2.5)
        }
        .frame(height: 40)
        .padding(.horizontal, 10)
        .background {
            Color.white
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke((kategory?.color == nil ? .gray : Color(hex: kategory!.color!)).opacity(0.8), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
        }
        .padding(2.5)
        .onChange(of: isDone) { _, new in
            onUpdate("isDone", new)
        }
        .onChange(of: isMarked) { _, new in
            onUpdate("isMarked", new)
        }
    }
}

#Preview {
    let item = ServiceWork().getDoneWork("스위프트유아이에서 전역적으로 상태를 관리하고 싶으시군요!")
    let item2 = ServiceWork().getNew("tod", parent: item)
    
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
    ItemTodo(item2) { key, value in
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
