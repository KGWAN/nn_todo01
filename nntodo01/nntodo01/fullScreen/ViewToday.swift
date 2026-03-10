//
//  ViewToday.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewToday: View {
    // state
    @State private var idRefresh: UUID = UUID()
    @State private var listToday: [Work] = []
    @State private var listMonth: [Work] = []
    @State private var listYear: [Work] = []
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // writing work
    @State private var isEditing: Bool = false
    @FocusState private var isFocusedSub: Bool
    @State private var textTitle: String = ""
    @State private var targetNum: TypePlan? = nil
    // value
    private let service = ServiceWork()
    private let dateToday = Date()
    private let calendar: Calendar = .nn
    private let listSection: [TypePlan] = [.day, .month, .year]
    // init
    private let predicateToday: NSPredicate
    private let predicateMonth: NSPredicate
    private let predicateYear: NSPredicate
    init() {
        // today
        self.predicateToday = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d AND planedMonth == %d AND planedDay == %d", TypePlan.day.rawValue, calendar.getYear(dateToday), calendar.getMonth(dateToday), calendar.getDay(dateToday))
        // month
        self.predicateMonth = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d AND planedMonth == %d", TypePlan.month.rawValue, calendar.getYear(dateToday), calendar.getMonth(dateToday))
        // year
        self.predicateYear = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.year.rawValue, calendar.getYear(dateToday))
    }
    
    var body: some View {
        ScrollView {
            ForEach(listSection, id: \.self) {type in
                Section {
                    VStack(spacing: 20) {
                        // list
                        viewList(type)
                        // textField
                        if isEditing && targetNum == type {
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
                                        if !textTitle.isEmpty { write(on: type) }
                                        // text 초기화
                                        textTitle = ""
                                    }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .padding(.horizontal, 10)
                            .border(Color.gray)

                        }
                    }
                } header: {
                    viewHeader(type)
                }
            }
        }
        .padding(.vertical, 10)
        .id(idRefresh)
        .onAppear {
            reload()
        }
    }
    
    
    // viewBuilder
    @ViewBuilder
    private func viewList(_ type: TypePlan) -> some View {
        if getList(type).isEmpty {
            VStack(spacing: 0) {
                Text("할 일이 존재하지 않습니다.")
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
        } else {
            ForEach(getList(type), id: \.id) { todo in
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
        }
    }
    
    @ViewBuilder
    private func viewHeader(_ type: TypePlan) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                // 제목
                Group {
                    if type == .day {
                        Text("오늘의 할 일")
                    } else if type == .month {
                        Text("이번 달의 할 일")
                    } else if type == .year {
                        Text("올 해의 할 일")
                    }
                }
                .font(.system(size: 20, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                // 생성 버튼
                Button {
                    isEditing = true
                    isFocusedSub = true
                    targetNum = type
                } label: {
                    ImgSafe("iconPlus", color: .cyan)
                        .frame(width: 15, height: 15)
                        .padding(5)
                        .border(.cyan)
                }
            }
            // 구분선
            Divider()
                .frame(height: 0.5)
                .background(.black)
        }
    }
    
    // func
    private func reload() {
        listToday = service.fetchList(predicateToday)
        listMonth = service.fetchList(predicateMonth)
        listYear = service.fetchList(predicateYear)
        // view refresh trager
        idRefresh = UUID()
    }
    
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func write(on type: TypePlan) {
        var isSuccess = false
        if type == .day {
            isSuccess = service.create(
                textTitle,
                listTypePlan: .day,
                planedDay: calendar.getDay(dateToday),
                planedMonth: calendar.getMonth(dateToday),
                planedYear: calendar.getYear(dateToday)
            ).isSuccess
        } else if type == .month {
            isSuccess = service.create(
                textTitle,
                listTypePlan: .month,
                planedMonth: calendar.getMonth(dateToday),
                planedYear: calendar.getYear(dateToday)
            ).isSuccess
        } else if type == .year {
            isSuccess = service.create(
                textTitle,
                listTypePlan: .year,
                planedYear: calendar.getYear(dateToday)
            ).isSuccess
        }
        if !isSuccess {
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
    
    private func getList(_ type: TypePlan) -> [Work] {
        return if type == .day {
            listToday
        } else if type == .month {
            listMonth
        } else if type == .year {
            listYear
        } else {[]}
    }
}

#Preview {
    ViewToday()
}
