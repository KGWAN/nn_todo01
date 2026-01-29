//
//  ViewMain.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/5/26.
//

import SwiftUI

struct ViewMain: View {
    // init
    init() {
        self._list = State(initialValue: service.fetchAll())
    }
    // state
    @State private var isShowingPopupInputKategory: Bool = false
    @State private var list: [Kategory]
    @State private var idRefresh: UUID = UUID()
    // constatn
    private let service: ServiceKategory = ServiceKategory()
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: ViewSearchTodo()
                        ) {
                            // 검색
                            ImgSafe("")
                                .frame(width: 35, height: 35)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    ScrollView() {
                        VStack(spacing: 20) {
                            ForEach(Templete.allCases) { templete in
                                NavigationLink(
                                    destination: ViewListTodo(templete)
                                ) {
                                    ItemInventory(templete.rawValue, imgName: "")
                                }
                            }
                        }
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        VStack(spacing: 20) {
                            ForEach(list) { kate in
                                NavigationLink(
                                    destination: ViewListTodo(kate)
                                ) {
                                    ItemInventory(kate.title ?? "", imgName: "")
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    Button {
                        isShowingPopupInputKategory = true
                    } label: {
                        HStack {
                            ImgSafe("")
                                .frame(width: 40, height: 40)
                            Text("새 목록")
                                .foregroundStyle(Color.blue)
                                .padding(.horizontal, 10)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            if isShowingPopupInputKategory {
                PopupInputKategory(isPresented: $isShowingPopupInputKategory) { result in
                    onCreateKategory(result)
                }
            }
        }
    }
    
    // func
    private func reload() {
        list = service.fetchAll()
        idRefresh = UUID()
    }
    
    private func onCreateKategory(_ result: Result) {
        if !result.isSuccess {
            //TODO: 토스트 띄우기 : 작업 생성에 실패
        }
        // 화면 갱신
        reload()
    }
}

#Preview {
    ViewMain()
}
