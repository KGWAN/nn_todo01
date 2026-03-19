//
//  ViewDetailTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ViewDetailTodo: View {
    // in value
    @State var item: Work
    private let onFinish: (Result) -> Void
    // init
    init(_ item: Work, onFinish: @escaping (Result) -> Void) {
        self._item = State(initialValue: item)
        self.onFinish = onFinish
        
        self.isLocked = item.isLocked
        // 기본
//        self._textTitle = State(initialValue: item.title ?? "")
//        self._isDone = State(initialValue: item.isDone)
        // 추가
//        self._textMemo = State(initialValue: item.memo ?? "")
//        self._listSub = State(initialValue: service.getChildren(item))
        // 분류
//        self._isMarked = State(initialValue: item.isMarked)
//        self._planType = State(initialValue: item.listTypePlan)
//        self._planedDay = State(initialValue: Int(item.planedDay))
//        self._planedWeek = State(initialValue: Int(item.planedWeek))
//        self._planedMonth = State(initialValue: Int(item.planedMonth))
//        self._planedYear = State(initialValue: Int(item.planedYear))
//        self._kategory = State(initialValue: item.kategory)
        // plan
    }
    
    // state
    // work member
    // 기본
    @State private var textTitle: String = ""
    @State private var isDone: Bool = false
    @State private var textMemo: String = ""
    @State private var kategory: Kategory? = nil
    // 별표
    @State private var isMarked: Bool = false
    // 부모/자식
    @State private var listSub: [Work] = []
    // 계획
    @State private var planType: TypePlan = []
    @State private var planedDay: Int = 0
    @State private var planedWeek: Int = 0
    @State private var planedMonth: Int = 0
    @State private var planedYear: Int = 0
    // 기타
    @State private var idRefresh: UUID = UUID()
    // creating sub
    @State private var isEditingSub: Bool = false
    @State private var textTitleSub: String = ""
    @FocusState private var isFocusedSub: Bool
    // updating sub
    @State private var isModifyingSub: Bool = false
    @State private var targetModifying: Work? = nil
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // environment
    @Environment(\.dismiss) private var dismiss
    // constant
    private let service: ServiceWork = ServiceWork()
    private let format: String = "yyyy년MM월dd일"
    private let isLocked: Bool
    
    
    var body: some View {
        NavigationStack {
            // tool bar
            HStack {
                HStack(alignment: .center) {
                    // 뒤로가기 버튼
                    BtnImg("btnBack") {
                        onUpdate()
                        dismiss()
                    }
                    .frame(width: 30, height: 30)
                    TextFieldTitle(placeholder: "할 일의 이름을 바꾸어 보세요.", text: $textTitle)
                        .frame(maxWidth: .infinity)
                    // 층수
                    Text("lv \(item.depth)")
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 10)
                        .border(.gray)
                }
                Spacer()
                HStack(spacing: 5) {
                    // 완료 체크 버튼
                    BtnCheckImg("btnDone", isChecked: $isDone)
                        .frame(width: 25, height: 25)
                        .disabled(isLocked)
                    // 별표 체크 버튼
                    BtnCheckImg("btnStar", colorY: .yellow, isChecked: $isMarked)
                        .frame(width: 25, height: 25)
                }
            }
            .padding(.horizontal, 20)
            ScrollView {
                // 하위 작업
                VStack {
                    if isEditingSub {
                        // 하위 작업 작성 부분
                        ViewCreatingTodo(parent: item, isPresented: $isEditingSub) { result in
                            onCreateSub(result)
                        }
                    } else {
                        // 하위 작업 생성 부분
                        btnCreating
                    }
                    // 하위 작업 리스트
                    if !listSub.isEmpty {
                        // 리스트
                        viewList
                    } else {
                        if !(isEditingSub) {
                            // 리스트가 빈 경우 _ 가이드
                            viewEmptyList
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .background(Color.white)
                // 중단
                VStack {
                    // plan
                    
                    // 메모 입력
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $textMemo)
                            .frame(minHeight: 200)
                            .padding(12)
                        if textMemo.isEmpty {
                            Text("메모 추가")
                                .foregroundColor(.gray)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                        }
                    }
                    .frame(maxHeight: 200)
                    .border(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
                
                // 하단
                HStack {
                    if let date = item.updatedDate {
                        Text(date.getStrDate(format: format) + "에 수정됨")
                            .foregroundColor(.gray)
                    } else if let date = item.createdDate {
                        Text(date.getStrDate(format: format) + "에 생성됨")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    // 삭제 버튼
                    BtnImg("btnDelete", color: .red) {
                        onDelete()
                        dismiss()
                    }
                    .frame(width: 35, height: 35)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
            }
            .background(Color.gray)
            .navigationBarBackButtonHidden()
            .toast(msgToast, isPresented: $isShowingToast)
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
            isEditingSub = false
        }
        .onChange(of: isDone) { _, _ in
            update("isDone", value: isDone)
        }
    }
    
    
    // ViewBuiler
    @ViewBuilder
    private var btnCreating: some View {
        Button {
            isEditingSub = true
        } label: {
            Text("이 버튼을 눌러 세부적인 일을 작성할 수 있어요.")
                .foregroundStyle(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(.cyan)
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
    private var viewList: some View {
        ForEach(listSub) { sub in
            NavigationLink(
                destination: ViewDetailTodo(sub) {result in
                    onUpdateSub(result)
                }
            ) {
                if isModifyingSub &&  sub == targetModifying {
                    // 수정 부분
                    ViewUpdatingTodo(
                        sub,
                        isPresented: $isModifyingSub
                    ) { k, v in
                        update(child: sub, key: k, value: v)
                    }
                } else {
                    ItemTodo(sub) {key, value in
                        update(child: sub, key: key, value: value)
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button() {
                            targetModifying = sub
                            isModifyingSub = true
                        } label: {
                            Label("이름 수정하기", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            delete(sub: sub)
                        } label: {
                            Label("삭제하기", systemImage: "trash")
                        }
                        Button(role: .destructive) {
                            deleteWithChildren(sub)
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
    // 리로드
    private func reload() {
        // 편집 모드 해제
        isEditingSub = false
        // 데이터 갱신
        if let i = item.id,
           let new = service.fetchOne(i) {
            item = new
            // 기본
            textTitle = item.title ?? ""
            textMemo = item.memo ?? ""
            kategory = item.kategory
            // state
            isDone = item.isDone
            // 별표
            isMarked = item.isMarked
            // child
            listSub = service.getChildren(item)
            // plan
            planType = item.listTypePlan
            planedYear = Int(item.planedYear)
            planedMonth = Int(item.planedMonth)
            planedWeek = Int(item.planedWeek)
            planedDay = Int(item.planedDay)
        }
        idRefresh = UUID()
    }
    // 단일 수정
    private func update(_ key: String, value: Any) {
        if !ServiceWork().update(item, key: key, value: value).isSuccess {
            showToast("작업 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    // 일괄 수정
    private func onUpdate() {
        // 기본
        item.title = textTitle
        item.isDone = isDone
        item.memo = textMemo
        item.isMarked = isMarked
        item.listTypePlan = planType
        item.planedDay = Int64(planedDay)
        item.planedWeek = Int64(planedWeek)
        item.planedMonth = Int64(planedMonth)
        item.planedYear = Int64(planedYear)
        item.kategory = kategory
        onFinish(service.update(item))
    }
    // Subwork
    // subwork 추가
    private func onCreateSub(_ result: Result) {
        if !result.isSuccess {
            showToast("서브 작업 생성에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    // subwork 수정
    private func update(child: Work, key: String, value: Any) {
        if !ServiceWork().update(child, key: key, value: value).isSuccess {
            showToast("서브 작업 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    private func onUpdateSub(_ result: Result) {
        if !result.isSuccess {
            showToast("서브 작업이 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    // subwork 삭제
    // 자신만 삭제
    private func delete(sub target: Work) {
        if !service
            .delete(target)
            .isSuccess {
            showToast("작업 삭제에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    // 자식과 함께 삭제
    private func deleteWithChildren(_ sub: Work) {
        if !service
            .deleteWithChildren(sub)
            .isSuccess {
            showToast("작업 삭제에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    

    // 삭제
    private func onDelete() {
        onFinish(service.delete(item))
    }
}

#Preview {
    let item = ServiceWork().getNew("todo example")
    let itemChild = ServiceWork().getNew("todo example child", parent: item)
    
    ViewDetailTodo(item) {
        NnLogger.log("result code: \($0)", level: .debug)
    }
}
