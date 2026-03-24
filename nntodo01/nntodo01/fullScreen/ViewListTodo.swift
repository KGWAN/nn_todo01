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
    @State private var idRefresh: UUID = UUID()
    @State private var list: [Work] = []
    @State private var title: String
    @State private var isEditing: Bool = false
    @State private var isModifyingName: Bool = false
    @State private var targetModifying: Work? = nil
    @State private var isShowingPopupAddTodo: Bool = false
    @State private var isShowingPopupSelectingKategory: Bool = false
    @State private var depth: Int = -1
    @State private var idxFilter: Int = -1 // -1: 전체, 0: 완료만 보기, 1: 미완료만 보기
    // showing toast
    @State private var isShowingToast: Bool = false
    @State private var msgToast: String = ""
    // constant
    private let service: ServiceWork = ServiceWork()
    private let predicate: NSPredicate?
    // environment
    @Environment(\.dismiss) private var dismiss
    // init
    let onDismiss: () -> Void
    
    // case: .normal, .marked
    init(_ templete: Templete = .normal, onDismiss: @escaping () -> Void) {
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
        self.templete = .normal
        self.kategory = kategory
        
        self._title = State(initialValue: kategory.title ?? "")
        self.predicate = NSPredicate(format: "kategory == %@", kategory)
        self._list = State(initialValue: service.fetchList(predicate!))
    }
    // state
    @State private var kategory: Kategory? = nil
    @State private var isShowingPopupModifyKategory: Bool = false
//    @State private var isPop: Bool = false
    
    
    // 연산 프로퍼티
    private var listFiltered: [Work] {
        skipOnDepth(skipOnDone(list))
    }
    private var availableDepths: [Int] {
        return Array(Set(list.map { Int($0.depth) })).sorted()
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경
//                background
                // 내용
                ContainerFloating {
                    VStack(spacing: 20) {
                        // header
                        viewHeader
                        // fillter
                        VStack {
                            HStack(spacing: 0) {
                                Text("완료여부")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 25)
                                Picker("LocalizedStringKey", selection: $idxFilter) {
                                    Text("전체").tag(-1)
                                    Text("완료").tag(0)
                                    Text("미완료").tag(1)
                                }
                                .pickerStyle(.palette)
                            }
                            .border(.gray.opacity(0.4))
                            .clipped()
                            if availableDepths.count > 0 {
                                HStack(spacing: 0) {
                                    Text("레밸")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 25)
                                    Picker("depth 선택", selection: $depth) {
                                        Text("전체").tag(-1)
                                        ForEach(availableDepths, id: \.self) {
                                            Text("\($0)").tag($0)
                                        }
                                    }
                                    .pickerStyle(.palette)
                                }
                                .border(.gray.opacity(0.4))
                                .clipped()
                            }
                        }
                        .padding(.horizontal, 20)
                        // 내용
                        VStack {
                            ScrollView {
                                VStack {
                                    // 할 일 목록 부분
                                    if isEditing {
                                        // 할 일 작성 부분
                                        viewWriting
                                    } else {
                                        // 생성 버튼
                                        btnCreating
                                    }
                                    if !list.isEmpty {
                                        // 리스트
                                        viewList
                                    } else {
                                        if !(isEditing) {
                                            // 리스트가 빈 경우 _ 가이드
                                        }
                                    }
                                }
                                .padding(.bottom, 50) // floating 버튼위로 띄우기 위함.
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                } label: {
                    if !isShowingPopupAddTodo
                    {
                        if kategory != nil {
                            // todo 추가 버튼
                            Button {
                                isShowingPopupAddTodo = true
                            } label: {
                                HStack(spacing: 0) {
                                    Text("기존 작업에서 추가")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
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
                    }
                }
                .padding(.top, 5)
                if isShowingPopupAddTodo {
                    // todo 추가 팝업
                    if let k = kategory {
                        // kategory의 경우
                        PopupSelectingTodo(
                            destination: k,
                            predicate: NSPredicate(format: "kategory == nil", k),
                            isPresented: $isShowingPopupAddTodo
                        ) { result in
                            onUpdate(result: result)
                        }
                    }
                }
                if kategory != nil && isShowingPopupModifyKategory {
                    // kategory 수정 팝업
                    PopupInputKategory(origin: kategory, isPresented: $isShowingPopupModifyKategory) { result in
                        onUpdateKategory(result: result)
                    } onDelete: { result in
                        onDeleteKategory(result: result)
                    }
                }
                if isShowingPopupSelectingKategory,
                   !isShowingPopupAddTodo,
                   !isShowingPopupModifyKategory {
                    PopupSelectingKategory(isPresented: $isShowingPopupSelectingKategory) { selectedKategory in
                        if let target = targetModifying {
                            update(target, key: "kategory", value: selectedKategory)
                        }
                    }
                }
            }
            .toast(msgToast, isPresented: $isShowingToast)
        }
        .id(idRefresh)
        .navigationBarBackButtonHidden()
        .contentShape(Rectangle()) // 빈 공간도 터치 가능하게 설정
        .onTapGesture {
            // 키보드를 내리는 코드
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            // 편집 모드 해제
            isEditing = false
        }
    }
    
    
    // ViewBuilder
    @ViewBuilder
    private var background: some View {
        if let kate = kategory {
            switch kate.markType {
            case TypeMarkKategory.photo.rawValue:
                if let name = kate.photo,
                    let img = UIImage(named: name) {
                    Image(uiImage: img)
                        .resizable()
                        .ignoresSafeArea()
                } else {
                    Color(hex: kate.color ?? ColorMarkKategory.allCases[0].rawValue)
                        .ignoresSafeArea()
                }
//                    case TypeMarkKategory.user.rawValue:
//                        if let path = kate.userPhoto?.path,
//                            let url = URL(string: path),
//                            let img = UIImage(contentsOfFile: url.path()) {
//                            Image(uiImage: img)
//                                .resizable()
//                                .ignoresSafeArea()
//                                .scaledToFill()
//                        } else {
//                            Color(hex: kate.color ?? ColorMarkKategory.allCases[0].rawValue)
//                                .ignoresSafeArea()
//                        }
            default:
                Color(hex: kate.color ?? ColorMarkKategory.allCases[0].rawValue)
                    .opacity(0.3)
                    .ignoresSafeArea()
            }
        } else {
            Color(hex: templete.hexColor)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private var viewHeader: some View {
        HStack {
            // leader
            HStack(spacing: 20){
                // 뒤로가기 버튼
                BtnImg("btnBack") {
                    onDismiss()
                    dismiss()
                }
                // 제목
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.black)
            }
            Spacer()
            // trailer
            HStack {
                if kategory != nil {
                    // 카테고리 수정 버튼
                    BtnImg("btnSetting") {
                        isShowingPopupModifyKategory = true
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // 할 일 작성 버튼
    @ViewBuilder
    private var btnCreating: some View {
        Button {
            isEditing = true
        } label: {
            Text("이 버튼을 눌러 할 일을 작성할 수 있어요.")
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
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
        .frame(height: 40)
    }
    
    // 할 일 목록
    @ViewBuilder
    private var viewList: some View {
        ForEach(listFiltered) { i in
            NavigationLink(
                destination: ViewDetailTodo(i) {result in
                    onUpdate(result: result)
                }
            ) {
                if isModifyingName &&  i == targetModifying {
                    // 수정 부분
                    ViewUpdatingTodo(
                        i,
                        isPresented: $isModifyingName
                    ) { k, v in
                        update(i, key: k, value: v)
                    }
                } else {
                    //
                    ItemTodo(i) {
                        update(i, key: $0, value: $1)
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button() {
                            targetModifying = i
                            isModifyingName = true
                        } label: {
                            Label("이름 수정", systemImage: "pencil")
                        }
                        Button() {
                            isShowingPopupSelectingKategory = true
                            targetModifying = i
                        } label: {
                            Label("다른 목록으로 이동", systemImage: "folder")
                        }
                        Button() {
                            update(i, key: "kategory", value: nil)
                        } label: {
                            Label("목록에서 제외", systemImage: "minus")
                        }
                        Button(role: .destructive) {
                            delete(i)
                        } label: {
                            Label("삭제하기", systemImage: "trash")
                        }
                        Button(role: .destructive) {
                            deleteWithChildren(i)
                        } label: {
                            Label("서브 작업까지 모두 삭제하기", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    // 할 일 목록 _ 비었을 때
    @ViewBuilder
    private var viewEmptyList: some View {
        VStack() {
            Text("작성된 할 일이 없어요.")
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var viewWriting: some View {
        if let k = kategory {
            ViewCreatingTodo(
                kategory: k,
                isPresented: $isEditing
            ) { result in
                onCreate(result)
            }
        } else {
            ViewCreatingTodo(
                templete: templete,
                isPresented: $isEditing
            ) { result in
                onCreate(result)
            }
        }
    }
    
    
    // func
    func showToast(_ msg: String) {
        msgToast = msg
        isShowingToast = true
        print(msg)
        print(isShowingToast)
    }
    
    private func reload() {
        // 편집 모드 해제
        isEditing = false
        //
        if predicate != nil {
            list = service.fetchList(predicate!)
        } else {
            list = service.fetchAll()
        }
        if let kate = kategory {
            title = kate.title ?? ""
        }
        // depth
        if depth != -1 && !availableDepths.contains(depth) {
            depth = -1
        }
        // view refresh trager
        idRefresh = UUID()
    }
    
    private func onCreate(_ result: Result) {
        if !result.isSuccess {
            showToast("작업 생성에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func update(_ item: Work, key: String, value: Any?) {
        if !service
            .update(item, key: key, value: value)
            .isSuccess {
            showToast("작업이 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func onUpdate(result: Result) {
        if !result.isSuccess {
            showToast("작업이 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func onUpdateKategory(result: Result) {
        if !result.isSuccess {
            showToast("케테고리 수정에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    private func onDeleteKategory(result: Result) {
        if result.isSuccess {
            onDismiss()
        } else {
            showToast("카테고리 삭제에 실패했습니다.")
            // 화면 갱신
            reload()
        }
    }
    
//    private func move(from source: IndexSet, to destination: Int) {
//        withAnimation {
//            list.move(fromOffsets: source, toOffset: destination)
//        }
//    }
    
    // 자신만 삭제
    private func delete(_ target: Work) {
        if !service
            .delete(target)
            .isSuccess {
            showToast("작업 삭제에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    // 자식과 함께 삭제
    private func deleteWithChildren(_ target: Work) {
        if !service
            .deleteWithChildren(target)
            .isSuccess {
            showToast("작업 삭제에 실패했습니다.")
        }
        // 화면 갱신
        reload()
    }
    
    // 분류
    private func skipOnDone(_ list: [Work]) -> [Work] {
        switch idxFilter {
        case 0:
            return list.filter{ $0.isDone == true }
        case 1:
            return list.filter{ $0.isDone == false }
        default:
            return list
        }
    }
    private func skipOnDepth(_ list: [Work]) -> [Work] {
        if depth < 0 {
            return list
        } else {
            return list.filter { $0.depth == depth }
        }
    }
}

#Preview {
    let kategory: Kategory = ServiceKategory().getNew("kate_preview", markType: TypeMarkKategory.photo.rawValue, photo: "bgKate00")
    
//    ViewListTodo(){}
//    ViewListTodo(.marked){}
    ViewListTodo(kategory, onDismiss: {})
}
