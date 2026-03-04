//
//  ViewToday.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewToday: View {
    // state
    @State private var listToday: [Work] = []
    @State private var listMonth: [Work] = []
    @State private var listYear: [Work] = []
    @State private var idRefresh: UUID = UUID()
    
    // value
    private let service = ServiceWork()
    private let date = Date()
    private let calendar: Calendar = .current
    
    // init
    private let predicateToday: NSPredicate
    private let predicateMonth: NSPredicate
    private let predicateYear: NSPredicate
    
    init() {
        // today
        self.predicateToday = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d AND planedMonth == %d AND planedDay == %d", TypePlan.day.rawValue, calendar.component(.year, from: date), calendar.component(.month, from: date), calendar.component(.day, from: date))
        self._listToday = State(initialValue: service.fetchList(predicateToday))
        // month
        self.predicateMonth = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d AND planedMonth == %d", TypePlan.month.rawValue, calendar.component(.year, from: date), calendar.component(.month, from: date))
        self._listMonth = State(initialValue: service.fetchList(predicateToday))
        // year
        self.predicateYear = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.year.rawValue, calendar.component(.year, from: date))
        self._listYear = State(initialValue: service.fetchList(predicateToday))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 오늘
                Text("ItemToday")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.2))
                // list
                if !listToday.isEmpty {
                    List {
                        ForEach(listToday) { i in
                            NavigationLink(
                                destination: ViewDetailTodo(i) {result in
//                                    onUpdate(result: result)
                                }
                            ) {
                                ItemTodo(i) {_,_ in 
//                                    update(i, key: $0, value: $1)
                                }
                            }
                            .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
//                            .onMove(perform: move)
//                        .onDelete(perform: delete)
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
                // 이번달
                Text("ItemMonth")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.2))
                // list
                if !listMonth.isEmpty {
                    List {
                        ForEach(listMonth) { i in
                            NavigationLink(
                                destination: ViewDetailTodo(i) {result in
//                                    onUpdate(result: result)
                                }
                            ) {
                                ItemTodo(i) {_,_ in
//                                    update(i, key: $0, value: $1)
                                }
                            }
                            .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
//                            .onMove(perform: move)
//                        .onDelete(perform: delete)
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
                // 올해
                Text("ItemYear")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.2))
                // list
                if !listYear.isEmpty {
                    List {
                        ForEach(listYear) { i in
                            NavigationLink(
                                destination: ViewDetailTodo(i) {result in
//                                    onUpdate(result: result)
                                }
                            ) {
                                ItemTodo(i) {_,_ in
//                                    update(i, key: $0, value: $1)
                                }
                            }
                            .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
//                            .onMove(perform: move)
//                        .onDelete(perform: delete)
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
            }
        }
        .padding(.vertical, 10)
        .id(idRefresh)
    }
    
    
    // func
    private func reload() {
        // view refresh trager
        idRefresh = UUID()
    }
}

#Preview {
    ViewToday()
}
