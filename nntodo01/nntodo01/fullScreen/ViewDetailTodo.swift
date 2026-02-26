//
//  ViewDetailTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ViewDetailTodo: View {
    // init
    @State var item: Work
    let onFinish: (Result) -> Void
    
    init(_ item: Work, onFinish: @escaping (Result) -> Void) {
        self._item = State(initialValue: item)
        self.onFinish = onFinish
        // 기본
        self._textTitle = State(initialValue: item.title ?? "")
        self._isDone = State(initialValue: item.isDone)
        // 추가
        self._textMemo = State(initialValue: item.memo ?? "")
        self._listSubwork = State(initialValue: service.getChildren(item))
        // 분류
        self._isMarked = State(initialValue: item.isMarked)
        self._planType = State(initialValue: item.listTypePlan)
        self._planedDay = State(initialValue: Int(item.planedDay))
        self._planedWeek = State(initialValue: Int(item.planedWeek))
        self._planedMonth = State(initialValue: Int(item.planedMonth))
        self._planedYear = State(initialValue: Int(item.planedYear))
        self._kategory = State(initialValue: item.kategory)
    }
    
    // state
    // work member
    // 기본
    @State private var textTitle: String
    @State private var isDone: Bool
    // 추가
    @State private var textMemo: String
    @State private var listSubwork: [Work]
    // 분류
    @State private var isMarked: Bool
    @State private var planType: TypePlan
    @State private var planedDay: Int
    @State private var planedWeek: Int
    @State private var planedMonth: Int
    @State private var planedYear: Int
    @State private var kategory: Kategory?
    // 기타
    @State private var idRefresh: UUID = UUID()
    @State private var isEditingSubwork: Bool = false
    @State private var textTitleSub: String = ""
    @FocusState private var isFocusedSub: Bool
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // environment
    @Environment(\.dismiss) private var dismiss
    // constant
    private let service: ServiceWork = ServiceWork()
    private let format: String = "yyyy년MM월dd일"
    
    var body: some View {
        NavigationStack {
            VStack {
                // 상단
                VStack {
                    // 서브 작업 리스트
                    List {
                        ForEach(listSubwork) { subwork in
                            ItemSubwork(subwork) {key, value in
                                update(child: subwork, key: key, value: value)
                            }
                            .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteChild)
                    }
                    .frame(height: CGFloat(listSubwork.count * 60))
                    .listStyle(.plain)
                    .scrollDisabled(true)
                    .listSectionSpacing(0)
                    .listSectionSeparator(.hidden)                    
                    if isEditingSubwork {
                        // 서브 작업 작성 영역
                        HStack {
                            BtnCheckImg("btnDone", isChecked: Binding(get: { false }, set: { _ in }))
                                .frame(width: 25, height: 25)
                                .disabled(true)
                            TextFieldTitle(placeholder: "서브 작업의 이름을 입력하세요.", text: $textTitleSub)
                                .focused($isFocusedSub)
                                .onChange(of: isFocusedSub) { _, new in
                                    isEditingSubwork = new
                                }
                                .submitLabel(.done)
                                .onSubmit {
                                    addSubwork(textTitleSub)
                                    textTitleSub = ""
                                }
                        }
                        .padding(.horizontal, 10)
                    } else {
                        // 서브 작업 추가 버튼
                        Button {
                            isEditingSubwork = true
                            isFocusedSub = true
                        } label: {
                            HStack {
                                ImgSafe("iconPlus", color: .cyan)
                                    .frame(width: 25, height: 25)
                                Text("서브 작업 추가")
                                    .foregroundStyle(Color.cyan)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .background(Color.white)
                // 중단
                VStack {
                    // 오늘 할일 추가 버튼
//                    BtnCheckFullWidth($isToday, strOn: "오늘 할 일에 추가됨", strOff: "오늘 할 일에 추가")
//                        .background(Color.white)
                    // 메모 입력
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $textMemo)
                            .padding(12)
                        if textMemo.isEmpty {
                            Text("메모 추가")
                                .foregroundColor(.gray)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                        }
                    }
                    .frame(maxHeight: 200)
                    .background(Color.white)
                    Spacer()
                    Text("todo detail")
                    Spacer()
                }
                .padding(.horizontal, 10)
                
                // 하단
                HStack {
                    if let date = item.updatedDate {
                        Text(date.getStrDate(format: format) + "에 수정됨")
                    } else if let date = item.createdDate {
                        Text(date.getStrDate(format: format) + "에 생성됨")
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        // 뒤로가기 버튼
                        BtnImg("btnBack") {
                            onUpdate()
                            dismiss()
                        }
                        .frame(width: 35, height: 35)
                        TextFieldTitle(placeholder: "작업이름을 바꾸어 보세요.", text: $textTitle)
                            .frame(maxWidth: .infinity)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        // 완료 체크 버튼
                        BtnCheckImg("btnDone", isChecked: $isDone)
                            .frame(width: 35, height: 35)
                        // 별표 체크 버튼
                        BtnCheckImg("btnStar", colorY: .yellow, isChecked: $isMarked)
                            .frame(width: 35, height: 35)
                    }
                }
            }
            .toast(msgToast, isPresented: $isShowingToast)
        }
        .id(idRefresh)
    }
    
    
    //MARK: func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    // 리로드
    private func reload() {
        if let i = item.id,
        let new = service.fetchOne(i) {
            item = new
        }
        listSubwork = service.getChildren(item)
        idRefresh = UUID()
    }
    // 일괄 수정
    private func onUpdate() {
        // 기본
        item.title = textTitle
        item.isDone = isDone
        item.memo = textMemo
//        item.children = listSubwork
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
    private func addSubwork(_ title: String) {
        if !service.addChild(title, target: item).isSuccess {
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
    // subwork 삭제
    private func deleteChild(at offsets: IndexSet) {
        if let idx = offsets.first {
            let subwork = listSubwork[idx]
            listSubwork.remove(at: idx)
            if !service.delete(subwork).isSuccess {
                showToast("서브 작업 삭제에 실패했습니다.")
            }
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
    let item = ServiceWork().getNew("todo example", isDone: true, isMarked: true)
    
    ViewDetailTodo(item) {
        NnLogger.log("result code: \($0)", level: .debug)
    }
}
