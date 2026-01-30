//
//  PopupInputTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//
//  Kategory's insert/update

import SwiftUI

struct PopupInputKategory: View {
    //init
    @Binding var isPresented: Bool
    var origin: Kategory? = nil
    let onFinish: (Result) -> Void
    
    init(
        isPresented: Binding<Bool>,
        origin: Kategory? = nil,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.origin = origin
        self.onFinish = onFinish
        
        self._text = State(initialValue: "")
        self._selectedRadio = State(initialValue: .color)
        self._selectedColor = State(initialValue: ColorMarkKategory.allCases[0])
    }
    // state
    @State private var canInput: Bool = false
    @State private var text: String
    @State private var selectedRadio: TypeMarkKategory
    @State private var selectedColor: ColorMarkKategory
    // value
    let service: ServiceKategory = ServiceKategory()
    
    
    var body: some View {
        ContainerPopup(
            .center,
            isPresented: $isPresented,
            content: {
                HStack {
                    VStack(spacing: 20) {
                        // popup title
                        Text(origin == nil ? "새 목록" : "목록 수정")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        // title
                        HStack {
                            ImgSafe("")
                                .frame(width: 40, height: 40)
                            TextFieldTitle(placeholder: "목록 제목", text: $text)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 10)
                        .onChange(of: text) { _, _ in
                            checkCanInput()
                        }
                        // mark
                        Group {
                            HStack(spacing: 15) {
                                ForEach(TypeMarkKategory.allCases, id: \.id) { mark in
                                    Button {
                                        selectedRadio = mark
                                    } label: {
                                        Text(mark.rawValue)
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundStyle(mark == selectedRadio ? Color.white : Color.gray)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 15)
                                            .background(mark == selectedRadio ? Color.cyan : Color.white)
                                            .border(mark == selectedRadio ? Color.cyan : Color.gray, width: 3)
                                    }
                                }
                                Spacer()
                            }
                            Group {
                                switch selectedRadio {
                                case .color:
                                    ViewSeletColorMarkKategory(selectedColor: $selectedColor)
                                case .photo:
                                    Text("사진 선택 (미구현)")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color.gray)
                                case .user:
                                    Text("사용자 지정 (미구현)")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        // button
                        HStack(spacing: 40) {
                            Spacer()
                            BtnText("취소") {
                                isPresented = false
                            }
                            BtnActivationText(origin == nil ? "목록 만들기" : "저장", isEnabled: $canInput) {
                                if origin == nil {
                                    create()
                                } else {
                                    update()
                                }
                                isPresented = false
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                }
                .padding(.horizontal, 40)
            }
        )
        .onAppear {
            if let kategory = origin {
                text = kategory.title ?? ""
                TypeMarkKategory.allCases.forEach { typeMark in
                    if typeMark.rawValue == kategory.markType {
                        selectedRadio = typeMark
                    }
                }
                ColorMarkKategory.allCases.forEach { colorMark in
                    if colorMark.rawValue == kategory.color {
                        selectedColor = colorMark
                    }
                }
            }
        }
    }
    
    
    // MARK: func
    private func checkCanInput() {
        canInput = !text.isEmpty
    }
    
    private func create() {
        onFinish(
            service.create(
                text,
                markType: selectedRadio.rawValue,
                color: selectedColor.rawValue
            )
        )
    }
    
    private func update(){
        if let new = origin {
            new.title = text
            new.markType = selectedRadio.rawValue
            new.color = selectedColor.rawValue
            
            onFinish(service.update(new))
        } else {
            NnLogger.log("update error: target kategorie not found.", level: .error)
            onFinish(Result(code: "9999", msg: "Invalid path: target kategorie not found."))
        }
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
    let kategory: Kategory = ServiceKategory().getNew("kate_preview")
    
    // insert
    PopupInputKategory(
        isPresented: $isShowing,
    ) { result in
        
    }
    // update
    PopupInputKategory(
        isPresented: $isShowing,
        origin: kategory
    ) { result in
        
    }
}
