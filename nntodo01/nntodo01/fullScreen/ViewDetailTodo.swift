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
        self._listSubWork = State(initialValue: (item.subworks as? Set<Subwork>)?.sorted(by: {
            $0.createdDate ?? Date() < $1.createdDate ?? Date()
        } ) ?? [])
    }
    
    // state
    @State private var idRefresh: UUID = UUID()
    @State private var textTitle: String
    @State private var isDone: Bool
    @State private var isMarked: Bool
    @State private var isToday: Bool
    @State private var listSubWork: [Subwork]
    @State private var isEditingSubwork: Bool = false
    @State private var textTitleSub: String = ""
    @FocusState private var isFocusedSub: Bool
    // environment
    @Environment(\.dismiss) private var dismiss
    // constant
    private let service: ServiceWork = ServiceWork()
    private let format: String = "yyyy년MM월dd일에 생성됨"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    VStack {
                        // 서브 작업 리스트
                        ForEach(listSubWork) { subwork in
                            ItemSubwork(subwork) {_, _ in
                                
                            }
                        }
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
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    // 오늘 할일 추가 버튼
                    BtnCheckFullWidth($isToday, strOn: "나의 하루에 추가됨", strOff: "나의 하루에 추가")
                        .border(.gray, width: 1)
                    Spacer()
                    Text("todo detail")
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                HStack {
                    Text((item.createdDate ?? Date()).getStrDate(format: format))
                    Spacer()
                    // 삭제 버튼
                    BtnImg("") {
                        onDelete()
                        dismiss()
                    }
                    .frame(width: 35, height: 35)
                }
                .padding(.horizontal, 20)
            }
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
        listSubWork = (item.subworks as? Set<Subwork>)?.sorted(by: {
            $0.createdDate ?? Date() < $1.createdDate ?? Date()
        }) ?? []
        idRefresh = UUID()
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
        
        onFinish(service.update(item))
    }
}

#Preview {
    let item = ServiceWork().getNewWork("todo example", isDone: false, isMarked: true)
    
    ViewDetailTodo(item) {
        NnLogger.log("result code: \($0)", level: .debug)
    }
}
