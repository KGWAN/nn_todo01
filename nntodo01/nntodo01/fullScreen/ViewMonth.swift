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
    @State private var isEditing: Bool = false
    @FocusState private var isFocusedSub: Bool
    @State private var textTitle: String = ""
    @State private var targetMonth: Int? = nil
    // value
    private var predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.month.rawValue, Calendar.nn.getYear(Date()))
    // constant
    private let listSection: [Int] = Array(1...12)
    private let year: Int = Calendar.nn.getYear(Date())
    private let service: ServiceWork = ServiceWork()
    
    // init
    init () {
        self._list = State(initialValue: service.fetchList(predicate))
        self._listGrouped = State(initialValue: Dictionary(grouping: list, by: { Int($0.planedMonth) }))
    }
    
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(listSection, id: \.self) { m in
                    // header
                    Section {
                        VStack {
                            // 월별 리스트
                            if let listTodo = listGrouped[Int(m)] {
                                ForEach(listTodo, id: \.id) { todo in
                                    ItemTodo(todo) {
                                        update(todo, key: $0, value: $1)
                                    }
                                    .contentShape(Rectangle())
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            delete(todo)
                                        } label: {
                                            Label("삭제하기", systemImage: "trash")
                                        }
                                    }
                                }
                            } else {
                                VStack(spacing: 0) {
                                    Text("할 일을 추가해주세요.")
                                        .foregroundStyle(Color.gray)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 10)
                                    Divider()
                                        .background(.gray)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 40)
                            }
                            
                            // 할 일 작성
                            if isEditing && targetMonth == m {
                                HStack {
                                    ImgSafe("btnDone", color: .gray)
                                        .frame(width: 25, height: 25)
                                    TextFieldTitle(placeholder: "할 일을 입력하세요.", text: $textTitle)
                                        .focused($isFocusedSub)
                                        .onChange(of: isFocusedSub) { _, new in
                                            isEditing = new
                                        }
                                        .submitLabel(.done)
                                        .onSubmit {
                                            if !textTitle.isEmpty { write(m) }
                                            // text 초기화
                                            textTitle = ""
                                        }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .padding(.horizontal, 10)
                                .border(Color.gray)
                   
                            }
                        }
                        .padding(.bottom, 30)
                    } header: {
                        viewHeader(m)
                    }
                    .padding(.horizontal, 10)
                }
            }
            .padding(.top, 10)
        }
        .id(idRefresh)
        .toast(msgToast, isPresented: $isShowingToast)
        .onAppear {
            reload()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocusedSub = false
            isEditing = false
        }
    }
    
    // viewBuilder
    private func viewHeader(_ month: Int) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(month) 월")
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    isEditing = true
                    isFocusedSub = true
                    targetMonth = month
                } label: {
                    ImgSafe("iconPlus", color: .cyan)
                        .frame(width: 15, height: 15)
                        .padding(5)
                        .border(.cyan)
                }
            }
            
            Divider()
                .frame(height: 0.5)
                .background(.black)
        }
    }
    
    // func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func reload() {
        list = service.fetchList(predicate)
        listGrouped = Dictionary(grouping: list, by: { Int($0.planedMonth) })
        idRefresh = UUID()
    }
    
    private func write(_ month: Int) {
        if !service.create(textTitle, listTypePlan: .month, planedMonth: month, planedYear: year).isSuccess {
            showToast("할 일이 작성되지 않았습니다.")
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
    
    private func delete(_ target: Work) {
        if !service
            .delete(target)
            .isSuccess {
            showToast("작업 삭제에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
}

#Preview {
    ViewMonth()
}
