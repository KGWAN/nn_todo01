//
//  ViewDetailTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct PopupDetailTodo: View {
    // in value
    @State var item: Work
    private let onFinish: (Result) -> Void
    // init
    init(_ item: Work, onFinish: @escaping (Result) -> Void) {
        self._item = State(initialValue: item)
        self.onFinish = onFinish
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
    @State private var cntWeek: Int = 0
    @State private var cntDate: Int = 0
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
    @EnvironmentObject private var managerPopup: ManagerPopup
    // constant
    private let service: ServiceWork = ServiceWork()
    private let format: String = "yyyy년MM월dd일"
    
    
    var body: some View {
        NavigationStack {
            // head
            viewHeader
            // content
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // 하위 작업 ---------------------------------------------
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
                                    // viewEmptyList
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        // --------------------------------------------------
                        // plan ---------------------------------------------
                        VStack(spacing: 5) {
                            ViewSelectingPlan(listTypePlan: $planType)
                            if !planType.isEmpty {
                                ViewAdjustingNum($planedYear, limit: 9999, labelText: "연도")
                                if planType != .year {
                                    ViewAdjustingNum($planedMonth, limit: 12, labelText: "월")
                                    if planType.contains(.week) {
                                        ViewAdjustingNum($planedWeek, limit: cntWeek, labelText: "주")
                                    }
                                    if planType.contains(.day) {
                                        ViewAdjustingNum($planedDay, limit: cntDate, labelText: "일")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        // --------------------------------------------------
                        // 메모 입력
                        viewWritingMemo
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        // footer
                        HStack {
                            Group {
                                if let date = item.updatedDate {
                                    Text(date.getStrDate(format: format) + "에 수정됨")
                                } else if let date = item.createdDate {
                                    Text(date.getStrDate(format: format) + "에 생성됨")
                                }
                            }
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            Spacer()
                            // 삭제 버튼
                            ImgSafe("btnDelete", color: .red)
                                .frame(width: 22.5, height: 22.5)
                                .padding(2.5)
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                }
                                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                                .padding(2.5)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        onDelete()
                                    } label: {
                                        Label("삭제하기", systemImage: "trash")
                                    }
                                    Button(role: .destructive) {
                                        onDeleteWithChildren()
                                    } label: {
                                        Label("서브 작업까지 모두 삭제하기", systemImage: "trash")
                                    }
                                }
                        }
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .background(Color.gray.opacity(0.2))
            .navigationBarBackButtonHidden()
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
        .onChange(of: planedYear) {_, new in
            print(new)
            resetLimitOfViewAdjustingNum()
        }
        .onChange(of: planedMonth) {_, new in
            print(new)
            resetLimitOfViewAdjustingNum()
        }
    }
    
    
    // ViewBuiler
    // header: tool bar
    @ViewBuilder
    private var viewHeader: some View {
        HStack {
            // lead
            HStack(alignment: .center) {
                // 뒤로가기 버튼
                BtnImg("btnBack") {
                    onUpdate()
                    managerPopup.hide()
                }
                .frame(width: 30, height: 30)
                HStack(spacing: 0) {
                    TextFieldTitle(placeholder: "할 일의 이름을 바꾸어 보세요.", text: $textTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 5)
                    // 층수
                    if item.depth > 0 {
                        Text("lv \(item.depth)")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal, 10)
                            .background {
                                Color.gray
                                    .cornerRadius(15)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    }
                                    .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                            }
                            .padding(2.5)
                    }
                }
                .frame(height: 30)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                .padding(2.5)
            }
            Spacer()
            //trail
            HStack(spacing: 5) {
                // 완료 체크 버튼
                BtnCheckImg("btnDone", isChecked: $isDone)
                    .frame(width: 22.5, height: 22.5)
                    .disabled(item.isLocked)
                // 별표 체크 버튼
                BtnCheckImg("btnStar", colorY: .yellow, isChecked: $isMarked)
                    .frame(width: 22.5, height: 22.5)
            }
            .padding(2.5)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
            .padding(2.5)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var btnCreating: some View {
        Button {
            isEditingSub = true
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
        ForEach(listSub) { sub in
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
                .onTapGesture {
//                    managerPopup.show(
//                        .viewDetailTodo(
//                            todo: sub,
//                            onFinished: { result in
//                                onUpdate(result: result)
//                            }
//                        )
//                    )
                }
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
    
    @ViewBuilder
    private var viewWritingMemo: some View {
        ZStack {
            // 간격 맞춰져 있음
            TextEditor(text: $textMemo)
                .font(.system(size: 14, weight: .light))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if textMemo.isEmpty {
                Text("메모 추가")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 5)
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background {
            Color.white
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
        }
        .padding(2.5)
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
            // 주와 날짜 한계 재설정
            resetLimitOfViewAdjustingNum()
        }
        idRefresh = UUID()
    }
    // 주와 날짜 한계 재설정
    private func resetLimitOfViewAdjustingNum() {
        // 마지막 주
        cntWeek = Calendar.nn.getWeeksInMonth(month: planedMonth, year: planedYear).count
        print("cntWeek >>> \(cntWeek)")
        // 마지막 날
        cntDate = Calendar.nn.getDaysInMonth(month: planedMonth, year: planedYear).count
        print("cntDate >>> \(cntDate)")
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
    // 자신만 삭제
    private func onDelete() {
        onFinish(service.delete(item))
    }
    // 자식과 함께 삭제
    private func onDeleteWithChildren() {
        onFinish(service.deleteWithChildren(item))
    }
    // Subwork ------------------------------------
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
    // -----------------------------------------------
}

#Preview {
    let item = ServiceWork().getNew("todo example", planedWeek: 4, planedMonth: 3, planedYear: 2026)
//    let itemChild = ServiceWork().getNew("todo example child", parent: item)
    
    PopupDetailTodo(item) {
        NnLogger.log("result code: \($0)", level: .debug)
    }
}
