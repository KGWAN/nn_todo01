//
//  PopupInputTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct PopupAddTodo: View {
    //init
    @Binding var isPresented: Bool
    let onUpdate: (Result) -> Void
    
    init(isPresented: Binding<Bool>, onUpdate: @escaping (Result) -> Void) {
        
        self._isPresented = isPresented
        self.onUpdate = onUpdate
        
        self._list = State(initialValue: service.fetchList(predicate))
    }
    // state
    @State private var text: String = ""
    @State private var list: [Work]
    @State private var idRefresh: UUID = UUID()
    // value
    private let service: ServiceWork = ServiceWork()
    private let predicate: NSPredicate = NSPredicate(format: "isDone != %@ AND isToday != %@", NSNumber(value: true), NSNumber(value: true))
    
    var body: some View {
        ContainerPopup(
            .bottom,
            isPresented: $isPresented,
            content: {
                VStack {
                    // list
                    if !list.isEmpty {
                        List {
                            ForEach(list) { i in
                                NavigationLink(
                                    destination: ViewDetailTodo(i) {_ in
                                        reload()
                                    }
                                ) {
                                    ItemAddTodo(i) {
                                        onUpdate(i, key: $0, value: $1)
                                    }
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        .id(idRefresh)
                    } else {
                        HStack {
                            Spacer()
                            Text("추가할 작업이 없습니다.")
                            Spacer()
                        }
                    }
                }
                .frame(minHeight: 300)
                .background(Color.white)
            }
        )
    }
    
    
    //func
    private func reload() {
        list = service.fetchList(predicate)
        idRefresh = UUID()
    }
    
    private func delete(at offsets: IndexSet) {
        if let idx = offsets.first {
            let work = list[idx]
            list.remove(at: idx)
            if !service
                .delete(work)
                .isSuccess {
                //TODO: 토스트 띄우기 : 작업 삭제에 실패
            }
        }
    }
    
    private func onUpdate(_ item: Work, key: String, value: Any) {
        let result = service.update(item, key: key, value: value)
        if !result.isSuccess {
            //TODO: 토스트 띄우기 : 작업 수정에 실패
        } else {
            onUpdate(result)
        }
        
        // 화면 갱신
        reload()
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
    
    PopupAddTodo(isPresented: $isShowing) { todo in
        NnLogger.log("(preview)Adding todo: \(todo)", level: .debug)
    }
}
