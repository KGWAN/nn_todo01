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
                VStack(spacing: 30) {
                    HStack {
//                        // 프로필
//                        NavigationLink(
//                            destination: ViewProfile()
//                        ) {
//                            HStack(alignment: .top, spacing: 5) {
//                                ImgSafe("profile", color: .gray)
//                                    .frame(width: 20, height: 20)
//                                    .padding(.horizontal, 5)
//                                VStack(alignment: .leading, spacing: 0) {
//                                    Text("이름")
//                                        .font(.system(size: 14))
//                                        .foregroundStyle(.black)
//                                        .padding(.horizontal, 5)
//                                        .padding(.vertical, 3)
//                                    Divider()
//                                        .padding(.horizontal, 5)
//                                }
//                            }
//                            .padding(5)
//                        }
                        Spacer()
                        NavigationLink(
                            destination: ViewSearchTodo()
                        ) {
                            // 검색
                            ImgSafe("btnSearch", color: .blue)
                                .frame(width: 35, height: 35)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    ScrollView() {
                        VStack(spacing: 20) {
                            ForEach(Templete.allCases) { templete in
                                NavigationLink(
                                    destination: ViewListTodo(
                                        templete,
                                        onDismiss: {
                                            reload()
                                        }
                                    )
                                ) {
                                    ItemInventory(
                                        templete.rawValue,
                                        nameImg: templete.nameIcon,
                                        color: templete.color,
                                        cnt: templete.cntNotDoneWorks
                                    )
                                }
                            }
                        }
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        VStack(spacing: 20) {
                            ForEach(list) { kate in
                                NavigationLink(
                                    destination: ViewListTodo(
                                        kate,
                                        onDismiss: {
                                            reload()
                                        }
                                    )
                                ) {
                                    if kate.markType == TypeMarkKategory.color.rawValue,
                                       let color = kate.color {
                                        ItemInventory(
                                            kate.title ?? "",
                                            nameImg: "iconTempNomal",
                                            color: Color(hex: color),
                                            cnt: service.getCntNotDoneWorks(kate)
                                        )
                                    } else {
                                        ItemInventory(kate.title ?? "", nameImg: "iconTempNomal", cnt: service.getCntNotDoneWorks(kate))
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    Button {
                        isShowingPopupInputKategory = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("새 목록")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.blue)
                                .padding(.horizontal, 10)
                        }
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
        .id(idRefresh)
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
