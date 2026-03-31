//
//  PopupSelectingTodo.swift
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
    init(destination kategory: Kategory, predicate: NSPredicate, onUpdate: @escaping (Result) -> Void) {
        self.onUpdate = onUpdate
        self.predicate = predicate
        self.kategory = kategory
        // dummy value
//        self.templete = .normal
    }
    init(to year: Int, predicate: NSPredicate, onUpdate: @escaping (Result) -> Void) {
        self.onUpdate = onUpdate
        self.predicate = predicate
        self.year = year
    }
    init(to month: Int, year: Int, predicate: NSPredicate, onUpdate: @escaping (Result) -> Void) {
        self.onUpdate = onUpdate
        self.predicate = predicate
        self.year = year
        self.month = month
    }
    init(toWeek week: Int, month: Int, year: Int, predicate: NSPredicate, onUpdate: @escaping (Result) -> Void) {
        self.onUpdate = onUpdate
        self.predicate = predicate
        self.year = year
        self.month = month
        self.week = week
    }
    init(toDay day: Int, month: Int, year: Int, predicate: NSPredicate, onUpdate: @escaping (Result) -> Void) {
        self.onUpdate = onUpdate
        self.predicate = predicate
        self.year = year
        self.month = month
        self.day = day
    }
    // in value
//    private let templete: Templete
    private let predicate: NSPredicate
    private let onUpdate: (Result) -> Void
    private var kategory: Kategory? = nil
    private var year: Int? = nil
    private var month: Int? = nil
    private var week: Int? = nil
    private var day: Int? = nil
    // state
    @State private var text: String = ""
    @State private var list: [Work] = []
    @State private var idRefresh: UUID = UUID()
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // value
    private let service: ServiceWork = ServiceWork()
    // environment
    @EnvironmentObject private var managerPopup: ManagerPopup
    
    
    var body: some View {
        ContainerPopup(
            .bottom,
            content: {
                ZStack {
                    // background
                    UnevenRoundedRectangle(
                        topLeadingRadius: 30,
                        topTrailingRadius: 30
                    )
                    .fill(Color.white)
                    .ignoresSafeArea(edges: .bottom)
                    .padding(.top, 30)
                    .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                    .padding(.top, 2.5)
                    // content
                    VStack(spacing: 0) {
                        // header
                        viewHeader
                        // list
                        VStack {
                            if !list.isEmpty {
                                ScrollView(showsIndicators: false) {
                                    VStack {
                                        ForEach(list) { i in
                                            Button {
                                                if let k = kategory {
                                                    update(i, key: "kategory", value: k)
                                                } else if let y = year {
                                                    if let m = month {
                                                        if let w = week {
                                                            i.listTypePlan = .week
                                                            i.planedWeek = Int64(w)
                                                        } else if let d = day {
                                                            i.listTypePlan = .day
                                                            i.planedDay = Int64(d)
                                                        } else {
                                                            i.listTypePlan = .month
                                                        }
                                                        i.planedMonth = Int64(m)
                                                    } else {
                                                        i.listTypePlan = .year
                                                    }
                                                    i.planedYear = Int64(y)
                                                    onUpdate(service.save())
                                                    managerPopup.hide()
                                                }
                                            } label: {
                                                ItemTodo(i)
                                                    .disabled(true)
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("추가할 작업이 없습니다.")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                }
            }
        )
        .id(idRefresh)
        .onAppear {
            reload()
        }
    }
    
    
    // ViewBuilder
    @ViewBuilder
    private var viewHeader: some View {
        VStack {
            ZStack() {
                Text("목록에 할 일 추가")
                    .frame(maxWidth: .infinity)
                // lead
                HStack {
                    // close button
                    BtnImg("iconX") {
                        managerPopup.hide()
                    }
                    Spacer()
                }
            }
            .frame(maxHeight: 30)
            .padding(.vertical, 20)
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
            onUpdate(result)
            managerPopup.hide()
        }
        
        // 화면 갱신
        reload()
    }
}

#Preview {
    PopupSelectingTodo(
        destination: ServiceKategory().getNew("kategory"),
        predicate: Templete.marked.predicateComplementary!
    ) { todo in
        NnLogger.log("(preview)Adding todo: \(todo)", level: .debug)
    }
}
