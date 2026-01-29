//
//  PopupInputTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct PopupInputKategory: View {
    //init
    @Binding var isPresented: Bool
    let onFinish: (Result) -> Void
    // state
    @State private var canInput: Bool = false
    @State private var text: String = ""
    @State private var selectedRadio: TypeMarkKategory = .color
    
    @State private var selectedColor: ColorMarkKategory = ColorMarkKategory.allCases[0]
    
    
    var body: some View {
        ContainerPopup(
            .center,
            isPresented: $isPresented,
            content: {
                HStack {
                    VStack(spacing: 20) {
                        // popup title
                        Text("새 목록")
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
                            BtnActivationText("목록 만들기", isEnabled: $canInput) {
                                onFinish(create(text))
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
    }
    
    
    // MARK: func
    private func checkCanInput() {
        canInput = !text.isEmpty
    }
    
    private func create(_ title: String) -> Result {
        return ServiceKategory().create(
            title,
            markType: selectedRadio.rawValue,
            color: selectedColor.rawValue
        )
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
    
    PopupInputKategory(
        isPresented: $isShowing,
    ) { result in
        
    }
}
