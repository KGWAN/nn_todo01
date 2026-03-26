//
//  ViewWeek.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/5/26.
//

import SwiftUI

struct ViewWeek: View {
    // init
    init(year: Int) {
        self.year = year
    }
    // in value
    private let year: Int
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
    // updating work
    @State private var isModifying: Bool = false
    @State private var targetModifying: Work? = nil
    @State private var month: Int = Calendar.nn.getMonth(Date())
    // constant
    private let service: ServiceWork = ServiceWork()
//    private let year: Int = Calendar.nn.getYear(Date())
    // environment
    @EnvironmentObject private var managerPopup: ManagerPopup
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                viewSelectingMonth
                ScrollView(showsIndicators: false) {
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
                    }
                }
            }
            .padding(.top, 5)
        }
        .id(idRefresh)
        .navigationBarBackButtonHidden()
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
     
    // ViewBuilder
    @ViewBuilder
    private var viewSelectingMonth: some View {
        HStack(spacing: 10) {
            BtnImgConditional(nameImg: "left", isEnabled: month > 1) {
                month -= 1
                reload()
            }
            Text("\(String(month))월 주별 할 일")
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
    private func viewHeader(_ week: Calendar.Week) -> some View {
        VStack(spacing: 5) {
            HStack {
                // 제목
                Text("\(week.num)주차 (\(week.startDate.getStrDate(format: "MM.dd")) - \(week.endDate.getStrDate(format: "MM.dd")))")
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                // 할 일 작성 버튼
                BtnImg("iconPlus", color: .cyan) {
                    targetNum = week.num
                    // 편집 모드 들어가기
                    isEditing = true
                }
            }
            // 구분선
            Divider()
                .frame(height: 1)
                .background(.gray.opacity(0.4))
        }
    }
    
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
    ViewWeek(year: 2026)
}
