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
    @State private var list: [Kategory]
    @State private var idRefresh: UUID = UUID()
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // constatn
    private let service: ServiceKategory = ServiceKategory()
    // environment
    @EnvironmentObject private var managerPopup: ManagerPopup
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 20) {
                    // header
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
                            ImgSafe("btnSearch", color: .cyan)
                                .frame(width: 22.5, height: 22.5)
                                .padding(2.5)
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
                    .frame(height: 30)
                    // content
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(Templete.allCases) { templete in
                                    NavigationLink(
                                        destination: ViewListTodo(
                                            templete,
                                            onDismiss: {_ in 
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
                                .padding(.vertical, 10)
                            VStack(spacing: 10) {
                                ForEach(list) { kate in
                                    NavigationLink(
                                        destination: ViewListTodo(
                                            kate,
                                            onDismiss: { rseult in
                                                print(rseult)
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
                        }
                    }
                    // 목록 생성 버튼
                    btnCreating
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 5)
            .toast(msgToast, isPresented: $isShowingToast)
        }
        .id(idRefresh)
    }
    
    
    // ViewBuilder
    @ViewBuilder
    private var btnCreating: some View {
        Button {
            managerPopup.show(
                .setKategory(
                    target: nil,
                    onFinished: { result in
                        onCreateKategory(result)
                    }, onDelete: nil
                )
            )
        } label: {
            HStack(spacing: 0) {
                ImgSafe("iconPlus", color: .white)
                    .frame(width: 40, height: 40)
                    .padding(2.5)
                Text("새 목록")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 40)
        .background {
            Color.cyan
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
        }
        .padding(2.5)
    }
    
    
    // func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func reload() {
        list = service.fetchAll()
        idRefresh = UUID()
    }
    
    private func onCreateKategory(_ result: Result) {
        if !result.isSuccess {
            showToast("카테고리 생성에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
}

#Preview {
    ViewMain()
}
