//
//  PopupChangingKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/23/26.
//

import SwiftUI

struct PopupSelectingKategory: View {
    // in value
    @Binding var isPresented: Bool
    private let onSelected: (Kategory) -> Void
    // init
    init(
        isPresented: Binding<Bool>,
        onSelected: @escaping (Kategory) -> Void
    ) {
        self._isPresented = isPresented
        self.onSelected = onSelected
    }
    // state
//    @State var target: Kategory
    @State private var list: [Kategory] = []
//    @State private var idRefresh: UUID = UUID()
    // constant
    private let service: ServiceKategory = ServiceKategory()
    // environment
    @Environment(\.isPreview) var isPreview
    
    var body: some View {
        ContainerPopup(
            .bottom,
            isPresented: $isPresented,
            content: {
                // background
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
                            ScrollView {
                                ForEach(list) { item in
                                    // button selecting a kategory
                                    Button {
                                        onSelected(item)
                                        isPresented = false
                                    } label: {
                                        ItemInventory(
                                            item.title ?? "",
                                            nameImg: "iconTempNomal",
                                            color: Color(hex: item.color ?? "#000000"),
                                            cnt: service.getCntNotDoneWorks(item)
                                        )
                                        .padding(.vertical, 5)
                                        .border(.gray)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                .padding(.top, 30)
            }
        )
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
                        isPresented = false
                    }
                    .frame(width: 30, height: 30)
                    .border(.gray)
                    Spacer()
                }
                // trail
                HStack {
                    Spacer()
                    // button creating kategory
                    BtnImg("iconPlus", color: .cyan) {
                        
                    }
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .border(.cyan)
                }
            }
            .frame(maxHeight: 30)
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
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
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    
    PopupSelectingKategory(isPresented: $isPresented) {
        print("kategory was selected. >>> \($0)")
    }
}
