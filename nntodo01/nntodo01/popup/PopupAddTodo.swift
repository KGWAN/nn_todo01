//
//  PopupInputTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct PopupSelectingTodo: View {
    //init
//    init(destination templete: Templete = .normal, predicate: NSPredicate, isPresented: Binding<Bool>, onUpdate: @escaping (Result) -> Void) {
//        self._isPresented = isPresented
//        self.onUpdate = onUpdate
//        self.predicate = predicate
//        self.templete = templete
//        // dummy value
//        self.kategory = nil
//    }
    init(destination kategory: Kategory, predicate: NSPredicate, isPresented: Binding<Bool>, onUpdate: @escaping (Result) -> Void) {
        self._isPresented = isPresented
        self.onUpdate = onUpdate
        self.predicate = predicate
        self.kategory = kategory
        // dummy value
//        self.templete = .normal
    }
    // in value
//    private let templete: Templete
    private let kategory: Kategory?
    private let predicate: NSPredicate
    @Binding var isPresented: Bool
    private let onUpdate: (Result) -> Void
    // state
    @State private var text: String = ""
    @State private var list: [Work] = []
    @State private var idRefresh: UUID = UUID()
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // value
    private let service: ServiceWork = ServiceWork()
    
    
    var body: some View {
        ContainerPopup(
            .bottom,
            isPresented: $isPresented,
            content: {
                VStack {
                    // list
                    if !list.isEmpty {
                        ScrollView {
                            ForEach(list) { i in
                                //                                NavigationLink(
                                //                                    destination: ViewDetailTodo(i) {_ in
                                //                                        reload()
                                //                                    }
                                //                                ) {
                                Button {
                                    if let k = kategory {
                                        update(i, key: "kategory", value: k)
                                    } else {
                                        //                                        update(i, key: "kategory", value: kategory)
                                    }
                                } label: {
                                    ItemAddTodo(i) {
                                        update(i, key: $0, value: $1)
                                    }
                                }
                                //                                }
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("추가할 작업이 없습니다.")
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }
                }
                .frame(minHeight: 300, maxHeight: 500)
                .background(Color.white)
            }
        )
        .id(idRefresh)
        .onAppear {
            reload()
        }
    }
    
    
    //func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
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
                showToast("작업 삭제에 실패했습니다.")
            }
        }
    }
    
    private func update(_ item: Work, key: String, value: Any) {
        let result = service.update(item, key: key, value: value)
        if !result.isSuccess {
            showToast("할 일 추가에 실패했습니다.")
        } else {
            isPresented = false
            onUpdate(result)
        }
        
        // 화면 갱신
        reload()
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
    
    PopupSelectingTodo(
        destination: ServiceKategory().getNew("kategory"),
        predicate: Templete.marked.predicateComplementary!,
        isPresented: $isShowing
    ) { todo in
        NnLogger.log("(preview)Adding todo: \(todo)", level: .debug)
    }
}
