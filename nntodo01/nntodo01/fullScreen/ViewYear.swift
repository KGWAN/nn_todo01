//
//  ViewYear.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewYear: View {
    // init
    init(_ year: Int) {
        self.year = year
    }
    // in value
    private let year: Int
    // state
    @State private var idRefresh: UUID = UUID()
    @State private var list: [Work] = []
//    @State private var year: Int = Calendar.nn.getYear(Date())
    @State private var isEditing: Bool = false
    @State private var isModifying: Bool = false
    @State private var targetModifying: Work? = nil
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // constant
    private let service: ServiceWork = ServiceWork()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                // 제목
                viewHeader
                    .padding(.horizontal, 10)
                // 내용
                ScrollView {
                    if isEditing {
                        // 할 일 작성 부분
                        ViewCreatingTodo(year: year, isPresented: $isEditing) { result in
                            onCreate(result)
                        }
                    }
                    if list.isEmpty && !isEditing {
                        // 리스트가 빈 경우 _ 가이드
                        viewEmptyList
                    } else {
                        // 할 일 리스트
                        viewList
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .id(idRefresh)
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
    
    
    // ViewBuilder
    @ViewBuilder
    private var viewHeader: some View {
        HStack {
            // 연도 선택
            HStack(alignment: .center, spacing: 10) {
                Text("\(String(year))년 할 일")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.vertical, 5)
            }
            Spacer()
            // 할 일 작성 버튼
            Button {
                isEditing = true
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

    @ViewBuilder
    private var viewList: some View {
        ForEach(list) { i in
            NavigationLink(
                destination: ViewDetailTodo(i) {result in
                    onUpdate(result: result)
                }
            ) {
                if isModifying &&  i == targetModifying {
                    // 수정 부분
                    ViewUpdatingTodo(
                        i,
                        isPresented: $isModifying
                    ) { k, v in
                        update(i, key: k, value: v)
                    }
                } else {
                    ItemTodo(i) {
                        update(i, key: $0, value: $1)
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button() {
                            targetModifying = i
                            isModifying = true
                        } label: {
                            Label("이름 수정하기", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            delete(i)
                        } label: {
                            Label("삭제하기", systemImage: "trash")
                        }
                        Button(role: .destructive) {
                            deleteWithChildren(i)
                        } label: {
                            Label("서브 작업까지 모두 삭제하기", systemImage: "trash")
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
        isEditing = false
        let predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.year.rawValue, year)
        list = service.fetchList(predicate)
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
    @Previewable @State var year: Int = 2026
    
    ViewYear(year)
}
