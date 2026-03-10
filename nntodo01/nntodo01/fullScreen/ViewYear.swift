//
//  ViewYear.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewYear: View {
    // init
    init () {
        self._list = State(initialValue: service.fetchList(predicate))
    }
    
    // state
    @State private var idRefresh: UUID = UUID()
    @State private var list: [Work] = []
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    @State private var year: Int = Calendar.nn.getYear(Date())
    @State private var isShowingPopupAddTodo: Bool = false
    @State private var isEditing: Bool = false
    @FocusState private var isFocusedSub: Bool
    @State private var textTitle: String = ""
    // constant
    private let service: ServiceWork = ServiceWork()
    // value
    private var predicate: NSPredicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d", TypePlan.year.rawValue, Calendar.nn.getYear(Date()))
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Group {
                        Text("Yearly plan: (\(String(year)))")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 5)
                        Divider()
                            .frame(height: 1)
                            .background(.black)
                    }
                    .padding(.horizontal, 10)
                    // 올해 목표 리스트
                    // list
                    Group {
                        if list.isEmpty {
                            VStack(spacing: 0) {
                                Text("할 일을 추가해주세요.")
                                    .foregroundStyle(Color.gray)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                Divider()
                                    .background(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40)
                        } else {
                            ForEach(list) { i in
                                NavigationLink(
                                    destination: ViewDetailTodo(i) {result in
                                        onUpdate(result: result)
                                    }
                                ) {
                                    ItemTodo(i) {
                                        update(i, key: $0, value: $1)
                                    }
                                    .contentShape(Rectangle())
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            delete(i)
                                        } label: {
                                            Label("삭제하기", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Group {
                        if isEditing {
                            HStack {
                                ImgSafe("btnDone", color: .gray)
                                    .frame(width: 25, height: 25)
                                TextFieldTitle(placeholder: "할 일을 입력하세요.", text: $textTitle)
                                    .focused($isFocusedSub)
                                    .onChange(of: isFocusedSub) { _, new in
                                        isEditing = new
                                    }
                                    .submitLabel(.done)
                                    .onSubmit {
                                        if !textTitle.isEmpty { write() }
                                        // text 초기화
                                        textTitle = ""
                                    }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .padding(.horizontal, 10)
                            .border(Color.gray)
//                            .padding(.trailing, 9) // 리스트와 맞추기는 했는데 수정할지도
                        } else {
                            // edit 모드로 들어가는 버튼
                            Button {
                                isEditing = true
                                isFocusedSub = true
                            } label: {
                                HStack {
                                    ImgSafe("iconPlus", color: .cyan)
                                        .frame(width: 25, height: 25)
                                    Text("할 일 추가")
                                        .foregroundStyle(Color.cyan)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .border(.cyan)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                }
                
                if isShowingPopupAddTodo {
                    // todo 추가 팝업
                    // TODO: 기존 작업에서 추가
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocusedSub = false
                isEditing = false
                
            }
        }
        .id(idRefresh)
    }
    
    
    //func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func reload() {
        list = service.fetchList(predicate)
        print(TypePlan.year.rawValue)
        print(list.count)
        idRefresh = UUID()
    }
    
    private func write() {
        if !service.create(textTitle, listTypePlan: .year, planedYear: year).isSuccess {
            showToast("할 일이 작성되지 않았습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func update(_ item: Work, key: String, value: Any) {
        if !service
            .update(item, key: key, value: value)
            .isSuccess {
            showToast("작업이 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func onUpdate(result: Result) {
        if !result.isSuccess {
            showToast("작업이 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func delete(_ target: Work) {
        if !service
            .delete(target)
            .isSuccess {
            showToast("작업 삭제에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
}

#Preview {
    ViewYear()
}
