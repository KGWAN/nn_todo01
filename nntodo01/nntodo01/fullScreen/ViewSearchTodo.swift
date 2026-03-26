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
    private let service: ServiceWork = ServiceWork()
    // environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var managerPopup: ManagerPopup
    
    var body: some View {
        NavigationStack {
            VStack {
                // 헤더
                viewHeader
                // 내용
                
                    if textSearch.isEmpty {
                        VStack(spacing: 0) {
                            Spacer()
                            ImgSafe("btnSearch", color: .gray.opacity(0.4))
                                .frame(width: 120, height: 120)
                                .padding(20)
                            Text("검색어를 통해 할 일을 검색할 수 있습니다.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.gray)
                                .frame(maxWidth:.infinity)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                            Text("검색어를 입력해보세요.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.gray)
                                .frame(maxWidth:.infinity)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                    } else if (listFiltered.isEmpty) {
                        VStack(spacing: 0) {
                            Spacer()
                            ImgSafe("btnSearch", color: .gray.opacity(0.4))
                                .frame(width: 120, height: 120)
                                .padding(20)
                            Text("검색어에 해당하는 할 일을 찾을 수 없습니다.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.gray)
                                .frame(maxWidth:.infinity)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                    } else {
                        VStack(spacing: 10) {
                            ScrollView {
                                ForEach(listFiltered) { i in
                                    ItemTodo(i) {
                                        onUpdate(i, key: $0, value: $1)
                                    }
                                    .onTapGesture {
                                        managerPopup.show(
                                            .viewDetailTodo(
                                                todo: i,
                                                onFinished: { result in
                                                    update(result)
                                                }
                                            )
                                        )
                                    }
                                }
                                .id(idRefresh)
                                Spacer()
                            }
                        }
                    }
                
            }
            .padding(.top, 5)
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden()
        .onChange(of: textSearch) { _, value in
            listFiltered = search(value)
        }
    }
    
    
    //
    @ViewBuilder
    private var viewHeader: some View {
        HStack(spacing: 5) {
            // leading
            HStack {
                // back button
                BtnImg("btnBack") {
                    dismiss()
                }
            }
            // trailing
            HStack(spacing: 0) {
                // search text
                TextFieldTitle(placeholder: "검색어를 입력하세요.", text: $textSearch)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 10)
                // 검색어 지우기
                if !textSearch.isEmpty {
                    Button {
                        textSearch = ""
                    } label: {
                        ImgSafe("iconX", color: .black)
                            .frame(width: 18.5, height: 18.5)
                            .padding(1.5)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            }
                            .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                            .padding(1.5)
                    }
                    .padding(.horizontal, 2.5)
                }
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
    
    private func update(_ result: Result) {
        if !result.isSuccess {
            showToast("작업 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
}

#Preview {
    ViewSearchTodo()
}
