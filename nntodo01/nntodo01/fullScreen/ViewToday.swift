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
    // updating work
    @State private var isModifying: Bool = false
    @State private var targetModifying: Work? = nil
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
        NavigationStack {
            ScrollView {
                ForEach(listSection, id: \.self) {type in
                    Section {
                        VStack(spacing: 20) {
                            if isEditing && targetNum == type {
                                // 할 일 작성 부분
                                viewWriting(type)
                            }
                            if let list = getList(type),
                               !list.isEmpty {
                                // 할 일 리스트
                                viewList(list)
                            } else {
                                if !(isEditing && targetNum == type) {
                                    viewEmptyList
                                }
                            }
                        }
                    } header: {
                        viewHeader(type)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal,20)
        }
        .id(idRefresh)
        .navigationBarBackButtonHidden()
        .onAppear {
            reload()
        }
    }
    
    
    // viewBuilder
    @ViewBuilder
    private func viewList(_ list: [Work]) -> some View {
        ForEach(list, id: \.id) { todo in
            NavigationLink(
                destination: ViewDetailTodo(todo) {result in
                    onUpdate(result: result)
                }
            ) {
                if isModifying &&  todo == targetModifying {
                    // 수정 부분
                    ViewUpdatingTodo(
                        todo,
                        isPresented: $isModifying
                    ) { k, v in
                        update(todo, key: k, value: v)
                    }
                } else {
                    ItemTodo(todo) {
                        update(todo, key: $0, value: $1)
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button() {
                            targetModifying = todo
                            isModifying = true
                        } label: {
                            Label("수정하기", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            delete(todo)
                        } label: {
                            Label("삭제하기", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var viewEmptyList: some View {
        VStack(spacing: 0) {
            Text("+ 버튼을 눌러 할 일을 작성할 수 있어요.")
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            Divider()
                .background(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
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
                .frame(height: 1)
                .background(.black)
        }
    }
    
    @ViewBuilder
    private func viewWriting(_ type: TypePlan) -> some View {
        let day = calendar.getDay(dateToday)
        let month = calendar.getMonth(dateToday)
        let year = calendar.getYear(dateToday)
        if type == .day {
            ViewCreatingTodo(day: day, month: month, year: year, isPresented: $isEditing) { result in
                onCreat(result)
            }
        } else if type == .month {
            ViewCreatingTodo(month: month, year: year, isPresented: $isEditing) { result in
                onCreat(result)
            }
        } else if type == .year {
            ViewCreatingTodo(year: year, isPresented: $isEditing) { result in
                onCreat(result)
            }
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
    
    private func onCreat(_ result: Result) {
        if !result.isSuccess {
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
    
    private func onUpdate(result: Result) {
        if !result.isSuccess {
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
    
    private func getList(_ type: TypePlan) -> [Work]? {
        return if type == .day {
            listToday
        } else if type == .month {
            listMonth
        } else if type == .year {
            listYear
        } else { nil }
    }
}

#Preview {
    ViewToday()
}
