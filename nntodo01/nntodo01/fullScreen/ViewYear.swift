//
//  ViewYear.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewYear: View {
    // init
    init() {
        self.year = Calendar.current.component(.year, from: Date())
        self.predicate = NSPredicate(format: "planType == %@ AND year == %@", TypePlan.year.rawValue, year)
    }
    // state
    @State private var isShowingPopupInputTodo: Bool = false
    @State private var idRefresh: UUID = UUID()
    @State private var list: [Work] = []
    // constant
    private let service: ServiceWork = ServiceWork()
    private let year: Int
    private let predicate: NSPredicate
    
    
    var body: some View {
        ZStack {
            ContainerBtnFloating {
                ScrollView {
                    Group {
                        Text("Yearly plan")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 5)
                        Divider()
                            .frame(height: 1)
                            .background(.black)
                    }
                    .padding(.horizontal, 10)
                    // 올해 목표 리스트
                }
            } labelBtn: {
                if !isShowingPopupInputTodo {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(35)
                        .padding(20)
                }
            } action: {
                isShowingPopupInputTodo = true
            }
            
            if isShowingPopupInputTodo {
                // new todo 생성 팝업
                PopupInputTodo(
                    year: year,
                    isPresented: $isShowingPopupInputTodo
                ) { result in
                    onAdd(result)
                }
            }
        }
        .id(idRefresh)
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
}

#Preview {
    ViewYear()
}
