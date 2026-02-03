//
//  ViewDetailTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ViewDetailTodo: View {
    // init
    @State private var item: Work
    let onFinish: (Result) -> Void
    
    init(_ item: Work, onFinish: @escaping (Result) -> Void) {
        self._item = State(initialValue: item)
        self.onFinish = onFinish
        
        self._textTitle = State(initialValue: item.title ?? "")
        self._isDone = State(initialValue: item.isDone)
        self._isMarked = State(initialValue: item.isMarked)
        self._isToday = State(initialValue: item.isToday)
        self._listSubwork = State(initialValue: (item.subworks as? Set<Subwork>)?.sorted(by: {
            $0.sortNum ?? "0" < $1.sortNum ?? "0"
        } ) ?? [])
        self._textMemo = State(initialValue: item.memo ?? "")
    }
    
    // state
    @State private var idRefresh: UUID = UUID()
    @State private var textTitle: String
    @State private var isDone: Bool
    @State private var isMarked: Bool
    @State private var isToday: Bool
    @State private var listSubwork: [Subwork]
    @State private var textMemo: String
    @State private var isEditingSubwork: Bool = false
    @State private var textTitleSub: String = ""
    @FocusState private var isFocusedSub: Bool
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
                            ItemSubwork(subwork) {_, _ in
                            }
                            .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                    .frame(height: CGFloat(listSubwork.count * 60))
                    .listStyle(.plain)
                    .scrollDisabled(true)
                    .listSectionSpacing(0)
                    .listSectionSeparator(.hidden)                    
                    if isEditingSubwork {
                        // 서브 작업 작성 영역
                        HStack {
                            BtnCheckImg(Binding(get: { false }, set: { _ in }))
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
                                ImgSafe()
                                    .frame(width: 25, height: 25)
                                Text("서브 작업 추가")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                Spacer()
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
                    BtnCheckFullWidth($isToday, strOn: "오늘 할 일에 추가됨", strOff: "오늘 할 일에 추가")
                        .background(Color.white)
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
                    BtnImg("") {
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
                        BtnImg("") {
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
                        BtnCheckImg($isDone)
                            .frame(width: 35, height: 35)
                        // 별표 체크 버튼
                        BtnCheckImg($isMarked)
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
        .id(idRefresh)
    }
    
    
    //MARK: func
    private func reload() {
        if let i = item.id,
        let new = service.fetchOne(i) {
            item = new
        }
        listSubwork = (item.subworks as? Set<Subwork>)?.sorted(by: {
            $0.sortNum ?? "0" < $1.sortNum ?? "0"
        }) ?? []
        idRefresh = UUID()
    }
    
    // Subwork
    private func move(from source: IndexSet, to destination: Int) {
        withAnimation {
            listSubwork.move(fromOffsets: source, toOffset: destination)
        }
        
        if !service.update(item, key: "subworks", value: listSubwork)
            .isSuccess {
            //TODO: 토스트 띄우기 : 서브 작업 수정에 실패
        }

        reload()
    }
    
    private func delete(at offsets: IndexSet) {
        if let idx = offsets.first {
            let subwork = listSubwork[idx]
            listSubwork.remove(at: idx)
            if !service.removeChild(subwork, target: item)
                .isSuccess {
                //TODO: 토스트 띄우기 : 서브 작업 삭제에 실패
            }
        }
    }
    
    private func update(_ target: Subwork, key: String, value: Any) {
        if !ServiceSubwork().update(target, key: key, value: value).isSuccess {
            //TODO: 토스트 띄우기 : 서브 작업 수정 실패
        }
        // 화면 갱신
        reload()
    }
    
    private func addSubwork(_ title: String) {
        if !service.addChild(title, target: item).isSuccess {
            //TODO: 토스트 띄우기 : 서브 작업 추가 실패
        }
        // 화면 갱신
        reload()
    }
    
    private func onDelete() {
        onFinish(service.delete(item))
    }
    
    private func onUpdate() {
        item.title = self.textTitle
        item.isDone = self.isDone
        item.isMarked = self.isMarked
        item.isToday = self.isToday
        item.memo = self.textMemo
        
        onFinish(service.update(item))
    }
}

#Preview {
    let item = ServiceWork().getNewWork("todo example", isDone: false, isMarked: true)
    
    ViewDetailTodo(item) {
        NnLogger.log("result code: \($0)", level: .debug)
    }
}
