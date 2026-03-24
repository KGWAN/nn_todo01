//
//  ViewUpdatingTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/13/26.
//

import SwiftUI

struct ViewUpdatingTodo: View {
    // init
    init(
        _ todo: Work,
        isPresented: Binding<Bool>,
        onUpdate: @escaping (String, Any) -> Void
    ){
        self.target = todo
        self._isPresented = isPresented
        self.onUpdate = onUpdate
    }
    // -------------------------------------------
    // constant ---------------------------------
    private let target: Work
    private let service: ServiceWork = ServiceWork()
    // callback
    private let onUpdate: (String, Any) -> Void
    // -------------------------------------------
    // state -------------------------------------
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @FocusState private var isFocusingOnField: Bool
    // -------------------------------------------
    
    var body: some View {
        // 수정 부분
        HStack(spacing: 5) {
            // 완료 여부 체크 버튼
            BtnCheckImg(
                "btnDone",
                colorY: .blue,
                isChecked: Binding(get: { target.isDone }, set: { _ in })
            )
            .frame(width: 25, height: 25)
            .padding(2.5)
            .disabled(true)
            // 이름
            TextFieldTitle(placeholder: "수정할 이름을 입력하세요.", text: $name)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .focused($isFocusingOnField)
                .onChange(of: isFocusingOnField) { _, new in
                    isPresented = new
                }
                .submitLabel(.done)
                .onSubmit {
                    // 생성
                    if !name.isEmpty {
                        onUpdate("title", name)
                    }
                    // 이름 초기화
                    name = ""
                    // 사라지기
                    isFocusingOnField = false
                    isPresented = false
                }
            // 즐겨찾기 여부 체크 버튼
            BtnCheckImg(
                "btnStar",
                colorY: .yellow,
                isChecked: Binding(get: { target.isDone }, set: { _ in })
            )
            .frame(width: 25, height: 25)
            .padding(2.5)
            .disabled(true)
        }
        .frame(height: 40)
        .padding(.horizontal, 10)
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
        .onAppear {
            name = target.title ?? ""
            isFocusingOnField = true
        }
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
    let item = ServiceWork().getNew("수정할 작업")
    
    ViewUpdatingTodo(
        item,
        isPresented: $isPresented,
        onUpdate: { print("key: \($0), newValue: \($1)") }
    )
}
