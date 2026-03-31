//
//  PopupInputKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//
//  Kategory's insert/update

import SwiftUI

struct PopupInputKategory: View {
    //in
    let origin: Kategory?
    let onFinish: (Result) -> Void
    let onDelete: ((Result) -> Void)?
    // init
    init(
        origin: Kategory? = nil,
        onFinish: @escaping (Result) -> Void,
        onDelete: ((Result) -> Void)? = nil
    ) {
        self.origin = origin
        self.onFinish = onFinish
        self.onDelete = onDelete
        
        self._text = State(initialValue: "")
        self._selectedRadio = State(initialValue: .color)
        self._selectedColor = State(initialValue: ColorMarkKategory.allCases[0])
        self._selectedPhoto = State(initialValue: PhotoMarkKategory.allCases[0])
        self._selectedUserPhoto = State(initialValue: origin?.userPhoto)
    }
    // state
    @State private var canInput: Bool = false
    @State private var text: String
    @State private var selectedRadio: TypeMarkKategory
    @State private var selectedColor: ColorMarkKategory
    @State private var selectedPhoto: PhotoMarkKategory
    @State private var selectedUserPhoto: UserPhoto? = nil
    // value
    let service: ServiceKategory = ServiceKategory()
    // environment
    @EnvironmentObject private var managerPopup: ManagerPopup
    
    
    var body: some View {
        ContainerPopup(
            .center,
            content: {
                HStack {
                    VStack(spacing: 20) {
                        // popup title
                        HStack(spacing: 0) {
                            Text(origin == nil ? "새 목록" : "목록 수정")
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if origin != nil {
                                BtnImg("btnDelete", color: .red) {
                                    delete()
                                }
                            }
                        }
                        // title
                        HStack {
                            ImgSafe("iconTempNomal", color: selectedColor.color)
                                .frame(width: 25, height: 25)
                                .padding(5)
                                .background(selectedColor.color.opacity(0.1))
                                .cornerRadius(15)
                            TextFieldTitle(placeholder: "목록 제목", text: $text, color: selectedColor.color.opacity(0.8))
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 10)
                        .onChange(of: text) { _, _ in
                            checkCanInput()
                        }
                        // mark
                        VStack(spacing: 5) {
                            HStack(spacing: 0) {
                                ForEach(TypeMarkKategory.allCases, id: \.id) { mark in
                                    Button {
                                        selectedRadio = mark
                                    } label: {
                                        Text(mark.rawValue)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(.black)
//                                            .foregroundStyle(.cyan)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .background {
                                                if selectedRadio == mark {
                                                    Color.white
                                                        .cornerRadius(15)
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(selectedColor.color.opacity(0.8), lineWidth: 1)
                                                        }
                                                        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                                                } else {
                                                    Color.clear
                                                }
                                            }
                                    }
                                }
                                .disabled(true)
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
                            //
                            Group {
                                switch selectedRadio {
                                case .color:
                                    ViewSelectColorMarkKategory(selectedOne: $selectedColor)
//                                case .photo:
//                                    ViewSelectPhotoMarkKategory(selectedOne: $selectedPhoto)
//                                case .user:
//                                    ViewSelectUserMarkKategory(for: $selectedUserPhoto)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        // button
                        HStack(spacing: 20) {
                            Spacer()
                            BtnText("취소") {
                                managerPopup.hide()
                            }
                            BtnActivationText(origin == nil ? "목록 만들기" : "저장", isEnabled: $canInput) {
                                if origin == nil {
                                    create()
                                } else {
                                    update()
                                }
                                managerPopup.hide()
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .cornerRadius(15)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                    .padding(2.5)
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
                description: nil,
                markType: selectedRadio.rawValue,
                color: selectedColor.rawValue,
                photo: selectedPhoto.rawValue,
                userPhoto: selectedUserPhoto
            )
        )
    }
    
    private func update(){
        if let new = origin {
            // set
            new.title = text
            new.markType = selectedRadio.rawValue
            new.color = selectedColor.rawValue
            new.photo = selectedPhoto.rawValue
            new.userPhoto = selectedUserPhoto
            // end
            onFinish(service.update(new))
        } else {
            NnLogger.log("update error: target kategorie not found.", level: .error)
            onFinish(Result(code: "9999", msg: "Invalid path: target kategorie not found."))
        }
    }
    
    private func delete() {
        if let kate = origin,
            let excute = onDelete {
            excute(service.delete(kate))
        }
    }
}

#Preview {
    let kategory: Kategory = ServiceKategory().getNew("kate_preview")
    
    // insert
    PopupInputKategory() { result in
        
    }
    // update
    PopupInputKategory(
        origin: kategory
    ) { result in
        
    }
}
