//
//  ViewSearchTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import SwiftUI

struct ViewSearchTodo: View {
    // state
    @State private var textSearch: String = ""
    @State private var listFiltered: [Work] = []
    @State private var idRefresh: UUID = UUID()
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // value
    private let service: ServiceWork = ServiceWork()    // environment
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                if textSearch.isEmpty {
                    ImgSafe("")
                        .frame(width: 120, height: 120)
                        .padding(20)
                    Text("무엇을 찾고 싶으신가요?")
                    Text("작업 내에서 검색할 수 있습니다.")
                } else if (listFiltered.isEmpty) {
                    ImgSafe("")
                        .frame(width: 120, height: 120)
                        .padding(20)
                    Text("검색어를 포함하는 작업을 찾을 수 없습니다.")
                } else {
                    List {
                        ForEach(listFiltered) { i in
                            NavigationLink(
                                destination: ViewDetailTodo(i) {_ in 
                                    reload()
                                }
                            ) {
                                ItemTodo(i) {
                                    onUpdate(i, key: $0, value: $1)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .id(idRefresh)
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        // back button
                        BtnImg("btnBack") {
                            dismiss()
                        }
                        .frame(width: 40, height: 40)
                        // search text
                        TextFieldTitle(placeholder: "검색어를 입력하세요.", text: $textSearch)
                            .frame(maxWidth: .infinity)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        // 검색어 지우기
                        if !textSearch.isEmpty {
                            BtnImg("iconX") {
                                textSearch = ""
                            }
                            .frame(width: 35, height: 35)
                        }
                    }
                }
            }
            .toast(msgToast, isPresented: $isShowingToast)
        }
        .onChange(of: textSearch) { _, value in
            listFiltered = search(value)
        }
    }
    
    
    //MARK: func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func reload() {
        listFiltered = search(textSearch)
        idRefresh = UUID()
    }
    
    private func search(_ text: String) -> [Work] {
        if textSearch.isEmpty {
            return []
        }
        return service.fetchList(
            NSPredicate(format: "title CONTAINS[c] %@", text),
            sort: [NSSortDescriptor(keyPath: \Work.createdDate, ascending: true)]
        )
    }
    
    private func delete(at offsets: IndexSet) {
        if let idx = offsets.first {
            let work = listFiltered[idx]
            listFiltered.remove(at: idx)
            if !service.delete(work).isSuccess {
                showToast("작업 삭제에 실패했습니다.")
            }
        }
    }
    
    private func onUpdate(_ item: Work, key: String, value: Any) {
        if !service.update(item, key: key, value: value).isSuccess {
            showToast("작업 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
}

#Preview {
    ViewSearchTodo()
}
