//
//  PopupChangingKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/23/26.
//

import SwiftUI

struct PopupSelectingKategory: View {
    // in value
    private let onSelected: (Kategory) -> Void
    // init
    init(
        onSelected: @escaping (Kategory) -> Void
    ) {
        self.onSelected = onSelected
    }
    // state
//    @State var target: Kategory
    @State private var list: [Kategory] = []
    @State private var idRefresh: UUID = UUID()
    @State private var isShowingPopupInputKategory: Bool = false
    // constant
    private let service: ServiceKategory = ServiceKategory()
    // environment
    @Environment(\.isPreview) var isPreview
    @EnvironmentObject private var managerPopup: ManagerPopup
    
    var body: some View {
        ZStack {
            ContainerPopup(
                .bottom,
                content: {
                    ZStack {
                        // background
                        UnevenRoundedRectangle(
                            topLeadingRadius: 30,
                            topTrailingRadius: 30
                        )
                        .fill(Color.white)
                        .ignoresSafeArea(edges: .bottom)
                        .padding(.top, 30)
                        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
                        .padding(.top, 2.5)
                        // contetn
                        VStack(spacing:0) {
                            // header
                            viewHeader
                            // body
                            VStack {
                                // list
                                if list.isEmpty {
                                    Text("선택할 목록이 없습니다.")
                                        .foregroundStyle(.gray)
                                } else {
                                    ScrollView(showsIndicators: false) {
                                        ForEach(list) { item in
                                            // button selecting a kategory
                                            Button {
                                                onSelected(item)
                                                managerPopup.hide()
                                            } label: {
                                                ItemInventory(
                                                    item.title ?? "",
                                                    nameImg: "iconTempNomal",
                                                    color: Color(hex: item.color ?? "#000000"),
                                                    cnt: service.getCntNotDoneWorks(item)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 30)
                        .padding(.horizontal, 20)
                    }
                }
            )
        }
        .onAppear {
            reload()
        }
    }
    
    // ViewBuilder
    @ViewBuilder
    private var viewHeader: some View {
        VStack {
            ZStack() {
                Text("목록에 추가")
                    .frame(maxWidth: .infinity)
                // lead
                HStack {
                    // close button
                    BtnImg("iconX") {
                        managerPopup.hide()
                    }
                    Spacer()
                }
                // trail
                HStack {
                    Spacer()
                    // button creating kategory
//                    BtnImg("iconPlus", color: .cyan) {
//                        isShowingPopupInputKategory = true
//                    }
                }
            }
            .frame(maxHeight: 30)
            .padding(.vertical, 20)
        }
    }
    
    
    // func
    private func reload() {
        // preview
        if isPreview {
            list.append(service.getNew("kategory_A"))
            list.append(service.getNew("kategory_B", color: "#0000FF"))
        } else {
            list = service.fetchAll()
        }
        //
        idRefresh = UUID()
    }
    
    private func onCreate(_ result: Result) {
        if !result.isSuccess {
            
        }
        reload()
    }
}

#Preview {
    PopupSelectingKategory {
        print("kategory was selected. >>> \($0)")
    }
    .environmentObject(ManagerPopup())
}
