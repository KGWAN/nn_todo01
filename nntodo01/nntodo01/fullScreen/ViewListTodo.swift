//
//  ViewListTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import SwiftUI

struct ViewListTodo: View {
    // common
    // state
    @State private var list: [Work] = []
    @State private var idRefresh: UUID = UUID()
    @State private var isShowingPopupInputTodo: Bool = false
    @State private var title: String
    @State private var isShowingPopupAddTodo: Bool = false
    // constant
    private let service: ServiceWork = ServiceWork()
    private let predicate: NSPredicate?
    // init
    let onDismiss: () -> Void
    
    // case: .nomal, .marked
    init(_ templete: Templete = .nomal, onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        self.templete = templete
        
        self._title = State(initialValue: templete.rawValue)
        self.predicate = templete.predicate
        if predicate != nil {
            self._list = State(initialValue: service.fetchList(predicate!))
        } else {
            self._list = State(initialValue: service.fetchAll())
        }
    }
    // constant
    private let templete: Templete

    // case: kategory
    init(_ kategory: Kategory, onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        self.templete = .nomal
        self.kategory = kategory
        
        self._title = State(initialValue: kategory.title ?? "")
        self.predicate = NSPredicate(format: "kategory == %@", kategory)
        self._list = State(initialValue: service.fetchList(predicate!))
    }
    // state
    @State private var kategory: Kategory? = nil
    @State private var isShowingPopupModifyKategory: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경
                if let kate = kategory {
                    switch kate.markType {
                    case TypeMarkKategory.photo.rawValue:
                        if let name = kate.photo,
                            let img = UIImage(named: name) {
                            Image(uiImage: img)
                                .resizable()
                                .ignoresSafeArea()
                                .scaledToFill()
                        } else {
                            Color(hex: kate.color ?? ColorMarkKategory.allCases[0].rawValue)
                                .ignoresSafeArea()
                        }
                    case TypeMarkKategory.user.rawValue:
                        if let path = kate.userPhoto?.path,
                            let url = URL(string: path),
                            let img = UIImage(contentsOfFile: url.path()) {
                            Image(uiImage: img)
                                .resizable()
                                .ignoresSafeArea()
                                .scaledToFill()
                        } else {
                            Color(hex: kate.color ?? ColorMarkKategory.allCases[0].rawValue)
                                .ignoresSafeArea()
                        }
                    default:
                        Color(hex: kate.color ?? ColorMarkKategory.allCases[0].rawValue)
                            .ignoresSafeArea()
                    }
                } else {
                    Color(hex: templete.hexColor)
                        .ignoresSafeArea()
                }
                // 내용
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
                                .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                                .listRowSpacing(0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
//                            .onMove(perform: move)
                            .onDelete(perform: delete)
                        }
                        .listStyle(.plain)
                        .listSectionSpacing(0)
                        .listSectionSeparator(.hidden)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 20)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    } else {
                        Text("할 일 목록이 여기에 나타납니다.")
                    }
                } label: {
                    if !isShowingPopupInputTodo &&
                        !isShowingPopupAddTodo
                    {
                        ZStack {
//                            if templete == .today {
//                                // todo 추가 버튼
//                                Button {
//                                    isShowingPopupAddTodo = true
//                                } label: {
//                                    HStack {
//                                        ImgSafe("iconAddPlan", color: .blue)
//                                            .frame(width: 25, height: 25)
//                                        Text("일정 추가")
//                                            .font(.system(size: 17, weight: .medium))
//                                            .foregroundStyle(Color.blue)
//                                    }
//                                    .frame(minHeight: 45)
//                                    .padding(.horizontal, 20)
//                                    .background(Color.white)
//                                    .cornerRadius(55)
//                                }
//                            }
                            
                            // new todo 생성 버튼
                            HStack {
                                Spacer()
                                Button {
                                    isShowingPopupInputTodo = true
                                } label: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .padding(20)
                                        .background(Color.white)
                                        .cornerRadius(35)
                                        .padding(20)
                                }
                            }
                        }
                    }
                }
                
                if isShowingPopupInputTodo {
                    // new todo 생성 팝업
                    PopupInputTodo(
                        templete: templete,
                        isPresented: $isShowingPopupInputTodo
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
                if kategory != nil && isShowingPopupModifyKategory {
                    // kategory 수정 팝업
                    PopupInputKategory(isPresented: $isShowingPopupModifyKategory, origin: kategory) { result in
                        onUpdateKategory(result: result)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .nnToolbar(
                title,
                onDismiss: { onDismiss() },
                contentTrailing: {
                    HStack {
                        if kategory != nil {
                            // 카테고리 수정 버튼
                            BtnImg("btnX") {
                                isShowingPopupModifyKategory = true
                            }
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                    }
                }
            )
        }
        .id(idRefresh)
    }
    
    
    //func
    private func reload() {
        if predicate != nil {
            list = service.fetchList(predicate!)
        } else {
            list = service.fetchAll()
        }
        if let kate = kategory {
            title = kate.title ?? ""
        }
        // view refresh trager
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
    
    private func onUpdateKategory(result: Result) {
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
    let kategory: Kategory = ServiceKategory().getNew("kate_preview", markType: TypeMarkKategory.photo.rawValue, photo: "bgKate00")
    
    ViewListTodo(){}
//    ViewListTodo(.today){}
//    ViewListTodo(.marked){}
//    ViewListTodo(kategory, onDismiss: {})
}
