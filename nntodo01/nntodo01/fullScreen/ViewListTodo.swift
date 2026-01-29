//
//  ViewListTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ViewListTodo: View {
    // init
    let templete: Templete
    
    init(_ templete: Templete = .nomal) {
        self.templete = templete
        
        if templete == .today {
            self.title = "\(templete.rawValue) (\(Date().getStrDate(format: "MM월dd일")))"
        } else {
            self.title = templete.rawValue
        }
        self.predicate = templete.predicate
        
        self._list = State(initialValue: service.fetchList(predicate))
    }
    init(_ kategory: Kategory) {
        self.templete = .nomal
        
        self.kategory = kategory
        self.title = kategory.title ?? ""
        self.predicate = NSPredicate(format: "kategory == %@", kategory)
        self._list = State(initialValue: service.fetchList(predicate))
    }
    // state
    @State private var list: [Work]
    @State private var idRefresh: UUID = UUID()
    @State private var isShowingPopupInputTodo: Bool = false
    @State private var isShowingPopupAddTodo: Bool = false
    @State private var kategory: Kategory? = nil
    // constant
    private let title: String
    private let service: ServiceWork = ServiceWork()
    // value
    private var predicate: NSPredicate? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                ContainerFloating {
                    // list
                    if !list.isEmpty {
                        List {
                            ForEach(list) { i in
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
//                            .onMove(perform: move)
                            .onDelete(perform: delete)
                        }
                        .id(idRefresh)
                    } else {
                        Text("할 일 목록이 여기에 나타납니다.")
                    }
                } label: {
                    if !isShowingPopupInputTodo &&
                        !isShowingPopupAddTodo
                    {
                        ZStack {
                            if templete == .today {
                                // todo 추가 버튼
                                Button {
                                    isShowingPopupAddTodo = true
                                } label: {
                                    HStack {
                                        ImgSafe("")
                                            .frame(width: 25, height: 25)
                                        Text("일정 추가")
                                            .foregroundStyle(Color.black)
                                    }
                                    .frame(minHeight: 45)
                                    .padding(.horizontal, 20)
                                    .background(Color.cyan)
                                    .cornerRadius(55)
                                }
                            }
                            
                            // new todo 생성 버튼
                            HStack {
                                Spacer()
                                Button {
                                    isShowingPopupInputTodo = true
                                } label: {
                                    ImgSafe("")
                                        .frame(width: 55, height: 55)
                                        .padding(20)
                                }
                            }
                        }
                    }
                }
                
                if isShowingPopupInputTodo {
                    // new todo 생성 팝업
                    PopupInputTodo(
                        isPresented: $isShowingPopupInputTodo,
                        templete: templete,
                        kategorie: kategory
                    ) { result in
                        onAdd(result)
                    }
                }
                if isShowingPopupAddTodo {
                    // todo 추가 팝업
                    PopupAddTodo(isPresented: $isShowingPopupAddTodo) { result in
                        onUpdate(result: result)
                    }
                }
            }
            .nnToolbar(title)
        }
    }
    
    
    //func
    private func reload() {
        list = service.fetchList(predicate)
        idRefresh = UUID()
    }
    
    private func onAdd(_ result: Result) {
        if !result.isSuccess {
            //TODO: 토스트 띄우기 : 작업 생성에 실패
        }
        // 화면 갱신
        reload()
    }
    
    private func onUpdate(_ item: Work, key: String, value: Any) {
        if !service
            .update(item, key: key, value: value)
            .isSuccess {
            //TODO: 토스트 띄우기 : 작업 수정에 실패
        }
        // 화면 갱신
        reload()
    }
    
    private func onUpdate(result: Result) {
        if !result.isSuccess {
            //TODO: 토스트 띄우기 : 작업 수정에 실패
        }
        // 화면 갱신
        reload()
    }
    
//    private func move(from source: IndexSet, to destination: Int) {
//        withAnimation {
//            list.move(fromOffsets: source, toOffset: destination)
//        }
//    }
    
    private func delete(at offsets: IndexSet) {
        if let idx = offsets.first {
            let work = list[idx]
            list.remove(at: idx)
            if !service
                .delete(work)
                .isSuccess {
                //TODO: 토스트 띄우기 : 작업 삭제에 실패
            }
        }
    }
}

#Preview {
    let kategory: Kategory = ServiceKategory().getNew("kate_preview")
    
//    ViewListTodo()
//    ViewListTodo(.today)
//    ViewListTodo(.marked)
//    ViewListTodo(.plan)
    ViewListTodo(kategory)
}
