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
    }
    
    // state
    @State private var textTitle: String
    @State private var isDone: Bool
    @State private var isMarked: Bool
    @State private var isToday: Bool
    // environment
    @Environment(\.dismiss) private var dismiss
    // constant
    private let service: ServiceWork = ServiceWork()
    private let format: String = "yyyy년MM월dd일에 생성됨"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
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
                ToolbarItem(placement: .navigationBarTrailing) {
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
    }
    
    
    //MARK: func
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
