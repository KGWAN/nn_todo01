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
    @State private var cntWeek: Int = 1
    @State private var cntDate: Int = 1
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
    private let arrYear: Array<Int> = Array(2000...2100)
    
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 0) {
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
                                    viewAdjusingPlan(
                                        title: "연도",
                                        range: arrYear,
                                        startPoint: planedYear > 0 ? planedYear : Calendar.nn.getYear(Date())
                                    ) { new in
                                        planedYear = new
                                    }
                                    if planType != .year {
                                        viewAdjusingPlan(
                                            title: "월",
                                            range: Array(1...12),
                                            startPoint: planedMonth > 0 ? planedMonth : Calendar.nn.getMonth(Date()),
                                        ) { new in
                                            planedMonth = new
                                        }
                                        if planType.contains(.week) {
                                            viewAdjusingPlan(
                                                title: "주",
                                                range: Array(1...cntWeek),
                                                startPoint: planedWeek > 0 ? planedWeek : Calendar.nn.getWeek(Date()),
                                            ) { new in
                                                planedWeek = new
                                            }
                                        }
                                        if planType.contains(.day) {
                                            viewAdjusingPlan(
                                                title: "일",
                                                range: Array(1...cntDate),
                                                startPoint: planedDay > 0 ? planedDay : Calendar.nn.getDay(Date()),
                                            ) { new in
                                                planedDay = new
                                            }
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
                                    .background(.white)
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
                                            managerPopup.hide()
                                        } label: {
                                            Label("삭제하기", systemImage: "trash")
                                        }
                                        Button(role: .destructive) {
                                            onDeleteWithChildren()
                                            managerPopup.hide()
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
            }
            .navigationBarBackButtonHidden()
            .background(Color.gray.opacity(0.2))
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
            resetLimitOfViewAdjustingNum(month: planedMonth, year: planedYear)
        }
        .onChange(of: planedMonth) {_, new in
            resetLimitOfViewAdjustingNum(month: planedMonth, year: planedYear)
        }
    }
    
    
    // ViewBuiler
    // header: tool bar
    @ViewBuilder
    private var viewHeader: some View {
        VStack {
            HStack {
                // lead
                HStack(alignment: .center) {
                    // 닫기 버튼
                    BtnImg("iconX") {
                        onUpdate()
                        managerPopup.hide()
                    }
                    .frame(width: 30, height: 30)
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
                if let parent = item.parent {
                    // 부모로 가기 버튼
                    BtnImg("btnInputTodo") {
                        onUpdate()
                        managerPopup.replace(
                            with:.viewDetailTodo(
                                todo: parent,
                                onFinished: { _ in
                                }
                            )
                        )
                    }
                    .frame(width: 30, height: 30)
                }
            }
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
                    .stroke((kategory?.color == nil ? .white.opacity(0.2) : Color(hex: kategory!.color!).opacity(0.8)), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
            .padding(2.5)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(.white)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
        .cornerRadius(15)
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
                    managerPopup.replace(
                        with:.viewDetailTodo(
                            todo: sub,
                            onFinished: { _ in
                            }
                        )
                    )
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
    
    @ViewBuilder
    private func viewAdjusingPlan(title: String, range: Array<Int>, startPoint: Int, onChange: @escaping (Int) -> Void) -> some View {
        HStack(spacing: 5) {
            Text(title)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
            PickerWheelHorizontal(
                range: range,
                startPoint: startPoint,
                onChange: onChange
            )
            .frame(height: 30)
            .padding(.horizontal, 10)
            .background(.white)
            .cornerRadius(15)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
            .padding(2.5)
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
            // 주와 날짜 한계 재설정
//            if let year = planedYear,
//               let month = planedMonth {
//                resetLimitOfViewAdjustingNum(month: month, year: year)
//            }
        }
        idRefresh = UUID()
    }
    // 주와 날짜 한계 재설정
    private func resetLimitOfViewAdjustingNum(month: Int, year: Int) {
        // 마지막 주
        cntWeek = Calendar.nn.getWeeksInMonth(month: month, year: year).count
        // 마지막 날
        cntDate = Calendar.nn.getDaysInMonth(month: month, year: year).count
        print(cntWeek)
        print(cntDate)
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
    let kategory = ServiceKategory().getNew("todo example", color: "#ff0000")
    let itemWithKategory = ServiceWork().getNew("todo example", kategory: kategory)
    let item = ServiceWork().getNew("todo example", planedMonth: 4, planedYear: 2026)
    let itemChild = ServiceWork().getNew("todo example child", parent: item)
    
    PopupDetailTodo(itemChild) {
        NnLogger.log("result code: \($0)", level: .debug)
    }
}
