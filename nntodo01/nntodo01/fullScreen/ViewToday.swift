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
    // environment
    @EnvironmentObject private var managerPopup: ManagerPopup
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
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(listSection, id: \.self) {type in
                        Section {
                            VStack(spacing: 10) {
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
                            .padding(.bottom, 30)
                        } header: {
                            viewHeader(type)
                        }
                    }
                }
            }
            .padding(.top, 5)
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
                .onTapGesture {
                    managerPopup.show(
                        .viewDetailTodo(
                            todo: todo,
                            onFinished: { result in
                                onUpdate(result: result)
                            }
                        )
                    )
                }
                .contextMenu {
                    Button() {
                        targetModifying = todo
                        isModifying = true
                    } label: {
                        Label("이름 수정하기", systemImage: "pencil")
                    }
                    Button() {
                        managerPopup.show(
                            .selectKategory(
                                onSelected: { kategory in
                                    update(todo, key: "kategory", value: kategory)
                                }
                            )
                        )
                    } label: {
                        Label("목록에 추가", systemImage: "folder.badge.plus")
                    }
                    Button(role: .destructive) {
                        delete(todo)
                    } label: {
                        Label("삭제하기", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteWithChildren(todo)
                    } label: {
                        Label("서브 작업까지 모두 삭제하기", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var viewEmptyList: some View {
        HStack {
            Text("+ 버튼을 눌러 할 일을 작성할 수 있어요.")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 10)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray.opacity(0.4), lineWidth: 1)
                }
        }
        .frame(height: 40)
        .padding(2.5)
    }
    
    @ViewBuilder
    private func viewHeader(_ type: TypePlan) -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                // 생성 버튼
                // 할 일 작성 버튼
                BtnImg("iconPlus", color: .cyan) {
                    isEditing = true
                    isFocusedSub = true
                    targetNum = type
                }
            }
            .frame(height: 30)
            // 구분선
            Divider()
                .frame(height: 1)
                .background(.gray.opacity(0.4))
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
    
    // 자신만 삭제
    private func delete(_ target: Work) {
        if !service
            .delete(target)
            .isSuccess {
            showToast("작업 삭제에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    // 자식과 함께 삭제
    private func deleteWithChildren(_ target: Work) {
        if !service
            .deleteWithChildren(target)
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
