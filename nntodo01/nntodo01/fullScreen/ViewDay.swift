//
//  ViewDay.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/10/26.
//

import SwiftUI

struct ViewDay: View {
    // init
    init(year: Int) {
        self.year = year
    }
    // in value
    private let year: Int
    // constant
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private let calendar = Calendar.nn
    private let dateBase: Date = Date()
    private let service: ServiceWork = ServiceWork()
    // state
    @State private var idRefresh: UUID = UUID()
    @State var dateSelected: Date? = nil
    @State private var list: [Work] = []
    @State private var month: Int = Calendar.nn.getMonth(Date())
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // writing todo
    @State private var isEditing: Bool = false
    // updating todo
    @State private var isModifying: Bool = false
    @State private var targetModifying: Work? = nil
    // environment
    @EnvironmentObject private var managerPopup: ManagerPopup
    
    
    // 현재 표시할 달의 첫 번째 날 구하기
    var firstDayOfMonth: Date {
        return calendar.getFirstDateOfMonth(month, year: year) ?? Date()
    }
    
    // 시작 요일 (1: 일요일, 7: 토요일)
    var startingWeekday: Int {
        return calendar.component(.weekday, from: firstDayOfMonth)
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // 헤더: 현재 연도와 월
                        viewSelectingMonth
                        // 날짜 그리드
                        viewCalendar
                        // 할 일 목록 부분
                        VStack {
                            HStack(spacing: 0) {
                                Spacer()
                                // 할 일 추가
                                BtnImg("bringTodo", color: .cyan, size: 30) {
                                    managerPopup.show(
                                        .selectTodoForAddToPlanDay(
                                            to: calendar.getDay(dateSelected!),
                                            month: month,
                                            year: year,
                                            predicate: NSPredicate(format: "planType == 0", TypePlan.year.rawValue),
                                            onUpdate: { result in
                                                reload()
                                            }
                                        )
                                    )
                                }
                                .disabled(dateSelected == nil)
                            }
                            .padding(.horizontal, 5)
                            if isEditing,
                               let date = dateSelected {
                                // 할 일 작성 부분
                                ViewCreatingTodo(
                                    day: calendar.getDay(date),
                                    month: calendar.getMonth(date),
                                    year: calendar.getYear(date),
                                    isPresented: $isEditing)
                                { result in
                                    onCreate(result)
                                }
                            } else {
                                // 생성 버튼
                                btnCreating
                            }
                            if !list.isEmpty {
                                // 리스트
                                viewList
                            } else {
                                if !(isEditing) {
                                    // 리스트가 빈 경우 _ 가이드
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .id(idRefresh)
        .navigationBarBackButtonHidden()
        .onAppear {
            dateSelected = dateBase
            reload()
        }
        .onChange(of: dateSelected, { _, _ in
            reload()
        })
        .toast(msgToast, isPresented: $isShowingToast)
        .contentShape(Rectangle()) // 빈 공간도 터치 가능하게 설정
        .onTapGesture {
            // 키보드를 내리는 코드
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            // 편집 모드 해제
            isEditing = false
        }
    }
    
    
    // viewBuilder
    @ViewBuilder
    private var viewSelectingMonth: some View {
        HStack(spacing: 10) {
            BtnImgConditional(nameImg: "left", isEnabled: month > 1) {
                month -= 1
                reload()
            }
            Text("\(String(month))월 일별 할 일")
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                .padding(2.5)
            BtnImgConditional(nameImg: "right", isEnabled: month < 12) {
                month += 1
                reload()
            }
        }
        .frame(height: 30)
    }
    
    @ViewBuilder
    private var viewCalendar: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            // 요일 표시줄
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
                    .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .primary))
            }
            
            // 시작 요일 전까지 빈 공간 채우기
            ForEach(0..<startingWeekday - 1, id: \.self) { _ in
                Text("")
            }
            
            // 실제 날짜 출력
            ForEach(Calendar.nn.getDaysInMonth(firstDay: firstDayOfMonth), id: \.self) { day in
                Button {
                    dateSelected = day
                } label: {
                    viewItem(day)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2.5)
    }
    
//    @ViewBuilder
//    private var viewEmptyList: some View {
//        VStack() {
//            Text("작성된 할 일이 없어요.")
//                .foregroundStyle(Color.gray)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 10)
//        }
//        .frame(maxWidth: .infinity)
//    }
    
    @ViewBuilder
    private var btnCreating: some View {
        Button {
            isEditing = true
        } label: {
            Text("이 버튼을 눌러 할 일을 작성할 수 있어요.")
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background {
                    Color.cyan
                        .cornerRadius(15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                }
                .padding(2.5)
        }
        .frame(height: 40)
        .padding(2.5)
    }
    
    @ViewBuilder
    private var viewList: some View {
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
                        Label("목록에 추가/이동", systemImage: "folder.badge.plus")
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
    private func viewItem(_ date: Date) -> some View {
        VStack {
            // TODO: 일 별 할 일 개수 표시
            Spacer()
            HStack {
                if let selected = dateSelected,
                    calendar.isDate(date, inSameDayAs: selected) {
                    // selected
                    Text(date.getStrDate(format: "d"))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.cyan)
                    // today
                } else if ( calendar.isDateInToday(date) ) {
                    Text(date.getStrDate(format: "d"))
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    // defalt
                } else {
                    Text(date.getStrDate(format: "d"))
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .padding(5)
        .background {
            Color.white
                .cornerRadius(15)
                .overlay {
                    if let selected = dateSelected,
                        calendar.isDate(date, inSameDayAs: selected) {
                        // selected
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.cyan.opacity(0.8), lineWidth: 1)
                        // today
                    } else if ( calendar.isDateInToday(date) ) {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.black.opacity(0.4), lineWidth: 1)
                        // defalt
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
        }
        .contentShape(Rectangle())
    }
    
    
    // func
    private func reload() {
        // 편집 모드 해제
        isEditing = false
        //
        if let date = dateSelected {
            let predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedDay == %d AND planedMonth == %d AND planedYear = %d", TypePlan.day.rawValue, calendar.getDay(date), calendar.getMonth(date), calendar.getYear(date))
            list = service.fetchList(predicate)
        }
        idRefresh = UUID()
    }
    
    // func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func onCreate(_ result: Result) {
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
}

#Preview {
    ViewDay(year: 2026)
}
