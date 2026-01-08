//
//  ViewListTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ViewListTodo: View {
    // init
    @State private var list: [Todo]
    
    init() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            let listDummy: [Todo] = [Todo("작업 1"), Todo("작업 2"), Todo("작업 3", isDone: true)]
            self._list = State(initialValue: listDummy)
        } else {
            self._list = State(initialValue: service.loadAll())
        }
    }
    // state
    @State private var isShowingPopupInputTodo: Bool = false
    // value
    private let service: ServiceTodo = ServiceTodo()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ContainerBtnFloating {
                    if !list.isEmpty {
                        List {
                            ForEach(list) { i in
                                NavigationLink(
                                    destination: ViewDetailTodo(
                                        i,
                                        onUpdate: { new in
                                            update(new)
                                        }, onDelete: { item in
                                            delete(item)
                                        }
                                    )
                                ) {
                                    ItemTodo(i) { new in
                                        update(new)
                                    }
                                }
                            }
                            .onMove(perform: move)
                            .onDelete(perform: delete)
                        }
                    } else {
                        Text("할 일 목록이 여기에 나타납니다.")
                    }
                } labelBtn: {
                    ImgSafe("")
                    .frame(width: 65, height: 65)
                    .padding(20)
                    .opacity(isShowingPopupInputTodo ? 0 : 1)
                } action: {
    //                NnLogger.log("move to add todo.", level: .debug)
                    isShowingPopupInputTodo = true
                }
                if isShowingPopupInputTodo {
                    PopupInputTodo(isPresented: $isShowingPopupInputTodo) { new in
                        add(new)
                    }
                }
            }
            .nnToolbar("작업 목록")
        }
    }
    
    //func
    private func add(_ item: Todo) {
        list.append(item)
        service.save(list)
    }
    
    private func delete(at offsets: IndexSet) {
        list.remove(atOffsets: offsets)
        service.save(list)
    }
    
    private func delete(_ item: Todo) {
        guard let idx = list.firstIndex(where: { $0.id == item.id }) else {
            NnLogger.log("It's failed to find the index of the item(\(item).", level: .error)
            return
        }
        
        list.remove(at: idx)
        service.save(list)
    }
    
    private func update(_ item: Todo) {
        guard let idx = list.firstIndex(where: { $0.id == item.id }) else {
            NnLogger.log("It's failed to find the index of the item(\(item).", level: .error)
            return
        }
        list[idx] = item
        service.save(list)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        NnLogger.log("Todo reordered", level: .info)
        withAnimation {
            list.move(fromOffsets: source, toOffset: destination)
            service.save(list)
        }
    }
}

#Preview {
    ViewListTodo()
}
