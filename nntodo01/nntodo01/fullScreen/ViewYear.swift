//
//  ViewYear.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewYear: View {
    // init
    init () {
        self._list = State(initialValue: service.fetchList(predicate))
    }
    
    // state
    @State private var isShowingPopupInputTodo: Bool = false
    @State private var idRefresh: UUID = UUID()
    @State private var list: [Work] = []
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    @State private var year: Int = Calendar.current.component(.year, from: Date())
    @State private var isShowingPopupAddTodo: Bool = false
    // constant
    private let service: ServiceWork = ServiceWork()
    // value
    private var predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.year.rawValue, Calendar.current.component(.year, from: Date()))
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                ContainerBtnFloating {
                    VStack {
                        Group {
                            Text("Yearly plan: (\(String(year)))")
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 5)
                            Divider()
                                .frame(height: 1)
                                .background(.black)
                        }
                        .padding(.horizontal, 10)
                        // 올해 목표 리스트
                        // list
                        if !list.isEmpty {
                            List {
                                ForEach(list) { i in
                                    NavigationLink(
                                        destination: ViewDetailTodo(i) {result in
                                            onUpdate(result: result)
                                        }
                                    ) {
                                        ItemTodo(i) {
                                            update(i, key: $0, value: $1)
                                        }
                                    }
                                    .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                                    .listRowSpacing(0)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete(perform: delete)
                                //                            .onMove(perform: move)
                            }
                            .listStyle(.plain)
                            .listSectionSpacing(0)
                            .listSectionSeparator(.hidden)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                        } else {
                            Text("할 일 목록이 여기에 나타납니다.")
                        }
                        Spacer()
                    }
                } labelBtn: {
                    if !isShowingPopupInputTodo {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(35)
                            .padding(20)
                    }
                } action: {
                    isShowingPopupInputTodo = true
                }
                .toast(msgToast, isPresented: $isShowingToast)
                
                if isShowingPopupInputTodo {
                    // new todo 생성 팝업
                    PopupInputTodo(
                        year: year,
                        isPresented: $isShowingPopupInputTodo
                    ) { result in
                        onAdd(result)
                    }
                }
                
                if isShowingPopupAddTodo {
                    // todo 추가 팝업
                    // TODO: 기존 작업에서 추가
                }
            }
        }
        .id(idRefresh)
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
        print(TypePlan.year.rawValue)
        print(list.count)
        idRefresh = UUID()
    }
    
    private func onAdd(_ result: Result) {
        if !result.isSuccess {
            showToast("작업 생성에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func update(_ item: Work, key: String, value: Any) {
        if !service
            .update(item, key: key, value: value)
            .isSuccess {
            showToast("작업이 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func onUpdate(result: Result) {
        if !result.isSuccess {
            showToast("작업이 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
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
}

#Preview {
    ViewYear()
}
