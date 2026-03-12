//
//  ViewDay.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/10/26.
//

import SwiftUI

struct ViewDay: View {
    // constant
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private let calendar = Calendar.nn
    private let dateBase: Date = Date()
    private let service: ServiceWork = ServiceWork()
    // state
    @State private var idRefresh: UUID = UUID()
    @State var dateSelected: Date? = nil
    @State private var list: [Work] = []
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // popup
    // writing todo
    @State private var isEditing: Bool = false
    
    
    // 현재 표시할 달의 첫 번째 날 구하기
    var firstDayOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: dateBase)
        return calendar.date(from: components)!
    }
    
    // 시작 요일 (1: 일요일, 7: 토요일)
    var startingWeekday: Int {
        return calendar.component(.weekday, from: firstDayOfMonth)
    }

    var body: some View {
        ZStack {
            ScrollView {
                // 헤더: 현재 연도와 월
                viewHeader
                // 날짜 그리드
                viewCalendar
                    .padding()
                // 할 일 목록 부분
                Group {
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
                            viewEmptyList
                        }
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
            }
        }
        .id(idRefresh)
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
    private var viewHeader: some View {
        Text(dateBase, format: .dateTime.year().month())
            .font(.title2.bold())
            .padding()
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
            ForEach(Calendar.nn.getDaysInCurrentMonth(), id: \.self) { day in
                Button {
                    dateSelected = day
                } label: {
                    viewItem(day)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private var viewEmptyList: some View {
        VStack() {
            Text("작성된 할 일이 없어요.")
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var btnCreating: some View {
        Button {
            isEditing = true
        } label: {
            Text("이 버튼을 눌러 할 일을 작성할 수 있어요.")
                .foregroundStyle(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(.cyan)
    }
    
    @ViewBuilder
    private var viewList: some View {
        ForEach(list, id: \.id) { todo in
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
    
    @ViewBuilder
    private func viewItem(_ date: Date) -> some View {
        VStack {
            // TODO: 일 별 할 일 개수 표시
            Spacer()
            
            // selected
            if let selected = dateSelected,
                calendar.isDate(date, inSameDayAs: selected) {
                Text(date.getStrDate(format: "d"))
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .foregroundColor(.white)
                // today
            } else if ( calendar.isDateInToday(date) ) {
                Text(date.getStrDate(format: "d"))
                    .frame(maxWidth: .infinity)
                    .background(.gray)
                    .foregroundColor(.black)
                // defalt
            } else {
                Text(date.getStrDate(format: "d"))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
            }
        }
        .frame(height: 60)
        .border(Color.gray)
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
    ViewDay()
}
