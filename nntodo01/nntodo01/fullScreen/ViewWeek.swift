//
//  ViewWeek.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/5/26.
//

import SwiftUI

struct ViewWeek: View {
    // state
    @State private var idRefresh: UUID = UUID()
    @State private var list: [Work] = []
    @State private var listGrouped: [Int: [Work]] = [:]
    @State private var listSection: [Calendar.Week] = []
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // writing work
    @State private var isEditing: Bool = false
    @State private var targetNum: Int? = nil
    // constant
    private let service: ServiceWork = ServiceWork()
    private let year: Int = Calendar.nn.getYear(Date())
    private let month: Int = Calendar.nn.getMonth(Date())
    
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(listSection) { w in
                    Section {
                        VStack {
                            if isEditing && targetNum == w.num {
                                // 할 일 작성 부분
                                ViewCreatingTodo(
                                    week: w.num,
                                    month: month,
                                    year: year,
                                    isPresented: $isEditing
                                ) { result in
                                    onCreate(result)
                                }
                            }
                            if let listTodo = listGrouped[w.num],
                               !listTodo.isEmpty {
                                // 할 일 리스트
                                viewList(listTodo)
                            } else {
                                if !(isEditing && targetNum == w.num) {
                                    // 리스트가 빈 경우 _ 가이드
                                    viewEmptyList
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    } header: {
                        viewHeader(w)
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
            // 키보드를 내리는 코드
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            // 편집 모드 해제
            isEditing = false
        }
    }
     
    // viewBuilder
    private func viewHeader(_ week: Calendar.Week) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                // 제목
                Text("\(week.num)주차 (\(week.startDate.getStrDate(format: "MM.dd")) - \(week.endDate.getStrDate(format: "MM.dd")))")
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                // 생성 버튼
                Button {
                    targetNum = week.num
                    // 편집 모드 들어가기
                    isEditing = true
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
    private func viewList(_ list: [Work]) -> some View {
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
    private var viewEmptyList: some View {
        VStack(spacing: 10) {
            Text("+ 버튼을 눌러 할 일을 작성할 수 있어요.")
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            Divider()
                .background(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
    
    
    // func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func reload() {
        // 편집 모드 해제
        isEditing = false
        listSection = Calendar.nn.getWeeksInMonth(month: month, year: year)
        let predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedMonth == %d AND planedYear == %d", TypePlan.week.rawValue, month, year)
        list = service.fetchList(predicate)
        listGrouped = Dictionary(grouping: list, by: { Int($0.planedWeek) })
        idRefresh = UUID()
    }
    
    private func onCreate(_ result: Result) {
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
    ViewWeek()
}
