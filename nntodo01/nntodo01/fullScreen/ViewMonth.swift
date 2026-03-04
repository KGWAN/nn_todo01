//
//  ViewMonth.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewMonth: View {
    // state
    @State private var idRefresh: UUID = UUID()
    @State private var list: [Work] = []
    @State private var listGrouped: [Int: [Work]] = [:]
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    @State private var isShowingPopupInputTodo: Bool = false
    // value
    private var predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.month.rawValue, Calendar.current.component(.year, from: Date()))
    // constant
    private let listSection: [Int] = Array(1...12)
    private let year: Int = Calendar.current.component(.year, from: Date())
    private let service: ServiceWork = ServiceWork()
    
    // init
    init () {
        self._list = State(initialValue: service.fetchList(predicate))
        self._listGrouped = State(initialValue: Dictionary(grouping: list, by: { Int($0.planedMonth) }))
    }
    
    
    var body: some View {
        ZStack {
            ContainerBtnFloating {
                NavigationStack {
                    List {
                        ForEach(listSection, id: \.self) { m in
                            // header
                            Section {
                                // 월별 리스트
                                if let listTodo = listGrouped[Int(m)] {
                                    ForEach(listTodo, id: \.id) { todo in
                                        Text(todo.title ?? "")
                                    }
                                } else {
                                    Text("일정이 없습니다.")
                                }
                            } header: {
                                Text("\(m) 월")
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Divider()
                                    .frame(height: 0.5)
                                    .background(.black)
                                    .padding(.bottom, 20)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
            } labelBtn: {
                if !isShowingPopupInputTodo {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(20)
                        .background(Color.yellow)
                        .cornerRadius(35)
                        .padding(20)
                }
            } action: {
                isShowingPopupInputTodo = true
            }
            
            if isShowingPopupInputTodo {
                // new todo 생성 팝업
                PopupInputTodo(month: 1, year: year, isPresented: $isShowingPopupInputTodo) { result in
                    onAdd(result)
                }
            }
        }
        .id(idRefresh)
        .toast(msgToast, isPresented: $isShowingToast)
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
        listGrouped = Dictionary(grouping: list, by: { Int($0.planedMonth) })
        print(TypePlan.month.rawValue)
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
}

#Preview {
    ViewMonth()
}
