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
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // writing todo
    @State private var isEditing: Bool = false
    @State private var targetMonth: Int? = nil
    // updating todo
    @State private var isModifying: Bool = false
    @State private var targetModifying: Work? = nil
    // constant
    private let listSection: [Int] = Array(1...12)
    private let year: Int = Calendar.nn.getYear(Date())
    private let service: ServiceWork = ServiceWork()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    ForEach(listSection, id: \.self) { m in
                        Section {
                            VStack {
                                if isEditing && targetMonth == m  {
                                    // 할 일 작성 부분
                                    ViewCreatingTodo(month: m, year: year, isPresented: $isEditing) { result in
                                        onCreate(result)
                                    }
                                }
                                if let listTodo = listGrouped[Int(m)], !listTodo.isEmpty {
                                    // 할 일 리스트
                                    viewList(listTodo)
                                } else {
                                    if !(isEditing && targetMonth == m) {
                                        // 리스트가 빈 경우 _ 가이드
                                        viewEmptyList
                                    }
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
        }
        .id(idRefresh)
        .navigationBarBackButtonHidden()
        .toast(msgToast, isPresented: $isShowingToast)
        .onAppear {
            reload()
        }
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
    private func viewHeader(_ month: Int) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(month) 월")
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                // 할 일 작성 버튼
                Button {
                    isEditing = true
                    targetMonth = month
                } label: {
                    ImgSafe("iconPlus", color: .cyan)
                        .frame(width: 15, height: 15)
                        .padding(5)
                        .border(.cyan)
                }
            }
            
            Divider()
                .frame(height: 1)
                .background(.black)
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
    private func viewList(_ list: [Work]) -> some View {
        ForEach(list, id: \.id) { todo in
            NavigationLink(
                destination: ViewDetailTodo(todo) {result in
                    onUpdate(result)
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
        let predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.month.rawValue, Calendar.nn.getYear(Date()))
        list = service.fetchList(predicate)
        listGrouped = Dictionary(grouping: list, by: { Int($0.planedMonth) })
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
    
    private func onUpdate(_ result: Result) {
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
}

#Preview {
    ViewMonth()
}
