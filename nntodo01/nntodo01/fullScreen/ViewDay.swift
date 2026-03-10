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
    private let dateStart: Date = Date()
    private let service: ServiceWork = ServiceWork()
    // state
    @State private var idRefresh: UUID = UUID()
    @State var dateSelected: Date? = nil
    @State private var list: [Work] = []
    @State private var isShowingPopupInputTodo: Bool = false
    @State private var isShowingPopupAddTodo: Bool = false
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    
    
    // 현재 표시할 달의 첫 번째 날 구하기
    var firstDayOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: dateStart)
        return calendar.date(from: components)!
    }
    
    // 이번 달의 총 일 수
    var daysInMonth: Int {
        return calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
    }
    
    // 시작 요일 (1: 일요일, 7: 토요일)
    var startingWeekday: Int {
        return calendar.component(.weekday, from: firstDayOfMonth)
    }

    var body: some View {
        ZStack {
            ContainerFloating {
                ScrollView {
                    // 헤더: 현재 연도와 월
                    Text(dateStart, format: .dateTime.year().month())
                        .font(.title2.bold())
                        .padding()
                    
                    // 요일 표시줄
                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.caption)
                                .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .primary))
                        }
                    }
                    
                    // 날짜 그리드
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
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
                        }
                    }
                    .padding()
                    
                    // 할 일 목록
                    if list.isEmpty {
                        VStack(spacing: 0) {
                            Spacer()
                            Text("할 일을 추가해주세요.")
                                .foregroundStyle(Color.gray)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                    } else {
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
                        Spacer()
                    }
                }
            } label: {
                if dateSelected != nil &&
                    !isShowingPopupInputTodo &&
                    !isShowingPopupAddTodo
                {
                    ZStack {
                        // todo 추가 버튼
//                        Button {
//                            isShowingPopupAddTodo = true
//                        } label: {
//                            HStack {
//                                Text("기존 작업에서 추가")
//                                    .font(.system(size: 17, weight: .medium))
//                                    .foregroundStyle(Color.cyan)
//                            }
//                            .frame(minHeight: 35)
//                            .padding(.horizontal, 20)
//                            .border(.cyan)
//                        }
                        
                        // new todo 생성 버튼
                        HStack {
                            Spacer()
                            BtnImg(
                                "iconPlus",
                                color: .white
                            ) {
                                isShowingPopupInputTodo = true
                            }
                            .frame(width: 20, height: 20)
                            .padding(10)
                            .background(Color.cyan)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            // new todo 생성 팝업
            if isShowingPopupInputTodo,
               let date = dateSelected {
                PopupInputTodo(
                    date: date,
                    isPresented: $isShowingPopupInputTodo
                ) { result in
                    onAdd(result)
                }
            }
            if isShowingPopupAddTodo {
                // todo 추가 팝업
                
            }
        }
        .id(idRefresh)
        .onAppear {
            dateSelected = dateStart
            reload()
        }
        .onChange(of: dateSelected, { _, _ in
            reload()
        })
        .toast(msgToast, isPresented: $isShowingToast)
        
        Spacer()
    }
    
    
    // viewBuilder
    @ViewBuilder
    private func viewItem(_ date: Date) -> some View {
        VStack {
            Spacer()
            Text("work cnt")
                .font(.system(size: 8))
                .foregroundStyle(.gray)
            Spacer()
            // selected
            if let selected = dateSelected,
                calendar.isDate(date, inSameDayAs: selected) {
                Text(date.getStrDate(format: "d"))
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .foregroundColor(.white)
                // today
            } else if ( isToday(date) ) {
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
    }
    
    // func
    // 오늘 날짜인지 확인하는 함수
    func isToday(_ day: Date) -> Bool {
        return calendar.isDateInToday(day)
    }
    
    private func reload() {
        if let date = dateSelected {
            list = service.fetchList(NSPredicate(format: "(planType & %d) != 0 AND planedDay == %d AND planedMonth == %d AND planedYear = %d", TypePlan.day.rawValue, calendar.getDay(date), calendar.getMonth(date), calendar.getYear(date)))
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
