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
    @State private var listFiltered: [Todo] = []
    // value
    private let service: ServiceTodo = ServiceTodo()
    // environment
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
                    ForEach(listFiltered) { i in
                        ItemTodo(i) { todo in
                            update(todo)
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        // back button
                        BtnImg("") {
                            dismiss()
                        }
                        .frame(width: 35, height: 35)
                        // search text
                        TextFieldTitle(placeholder: "검색어를 입력하세요.", text: $textSearch)
                            .frame(maxWidth: .infinity)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        // 검색어 지우기
                        BtnImg("") {
                            textSearch = ""
                        }
                        .frame(width: 35, height: 35)
                    }
                }
            }
        }
        .onChange(of: textSearch) { _, value in
            listFiltered = search(value)
        }
    }
    
    private func update(_ item: Todo) {
        guard let idx = listFiltered.firstIndex(where: { $0.id == item.id }) else {
            NnLogger.log("It's failed to find the index of the item(\(item).", level: .error)
            return
        }
        listFiltered[idx] = item
        service.save(listFiltered)
    }
    
    private func search(_ text: String) -> [Todo] {
        if textSearch.isEmpty {
            return []
        }

        return ServiceTodo().loadAll().filter {
            $0.title.localizedCaseInsensitiveContains(textSearch)
        }
    }
}

#Preview {
    ViewSearchTodo()
}
