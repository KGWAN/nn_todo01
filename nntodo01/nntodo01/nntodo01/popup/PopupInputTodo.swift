//
//  PopupInputTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct PopupInputTodo: View {
    // common
    //init
    @Binding var isPresented: Bool
    let onFinish: (Result) -> Void
    // state
    @State private var canInput: Bool = false
    @State private var text: String = ""
    // constant
    private let service: ServiceWork = ServiceWork()
    private let typePlan: TypePlan?
    private let year: Int?
    private let month: Int?
    private let day: Int?
    
    // case: .nomal, .today, .marked
    init(
        templete: Templete = .nomal,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.templete = templete
        // dummy
        self.typePlan = nil
        self.year = 0
        self.month = 0
        self.week = 0
        self.day = 0
        self.kategory = nil
    }
    // constant
    private let templete: Templete
    
    // case: kategory
    init(
        kategory: Kategory,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.templete = .nomal
        self.kategory = kategory
        // dummy
        self.typePlan = nil
        self.year = 0
        self.month = 0
        self.week = 0
        self.day = 0
    }
    // constant
    private let kategory: Kategory?
    
    // case: day
    init(
        date: Date,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.templete = .nomal
        self.typePlan = .day
        let cal = Calendar.current
        self.day = cal.component(.day, from: date)
        self.month = cal.component(.month, from: date)
        self.year = cal.component(.year, from: date)
        // dummy
        self.week = 0
        self.kategory = nil
    }
    
    // case: week
    init(
        week: Int,
        month: Int,
        year: Int,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.templete = .nomal
        self.typePlan = .week
        self.week = week
        self.month = month
        self.year = year
        // dummy
        self.day = 0
        self.kategory = nil
    }
    // constant
    private let week: Int?
    
    // case: month
    init(
        month: Int,
        year: Int,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.templete = .nomal
        self.typePlan = .month
        self.month = month
        self.year = year
        // dummy
        self.week = 0
        self.day = 0
        self.kategory = nil
    }
    
    // case: year
    init(
        year: Int,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.templete = .nomal
        self.typePlan = .month
        self.year = year
        // dummy
        self.month = 0
        self.week = 0
        self.day = 0
        self.kategory = nil
    }
    
    
    var body: some View {
        ContainerPopup(
            .bottom,
            isPresented: $isPresented,
            content: {
                HStack(alignment: .center, spacing: 10) {
                    BtnCheckImg("btnDone", isChecked: Binding(get: { false }, set: { _ in }))
                        .frame(width: 25, height: 25)
                        .disabled(true)
                    TextFieldTitle(placeholder: "작업추가", text: $text)
                        .frame(maxWidth: .infinity)
                    Button {
                        if canInput {
                            onFinish(create(text))
                            isPresented = false
                        }
                    } label: {
                        ImgSafe("btnInputTodo", color: Color.white)
                    }
                    .frame(width: 30, height: 30)
                    .background(canInput ? Color.cyan: Color.gray)
                    .cornerRadius(10)
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .onChange(of: text) { _, _ in
                    checkCanInput()
                }
                .background(Color.white)
            }
        )
    }
    
    
    // MARK: func
    private func checkCanInput() {
        canInput = !text.isEmpty
    }
    
    private func create(_ title: String) -> Result {
        if templete == .marked {
            return service.create(title, isMarked: true)
        } else if kategory != nil {
            return service.create(title, kategory: kategory)
        } else if typePlan == .day {
            return service.create(title, listTypePlan: typePlan!, planedDay: day!, planedMonth: month!, planedYear: year!)
        } else if typePlan == .week {
            return service.create(title, listTypePlan: typePlan!, planedWeek: week!, planedMonth: month!, planedYear: year!)
        } else if typePlan == .month {
            return service.create(title, listTypePlan: typePlan!, planedMonth: month!, planedYear: year!)
        } else if typePlan == .year {
            return service.create(title, listTypePlan: typePlan!, planedYear: year!)
        }
        return service.create(title)
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = true
    let kategory: Kategory = ServiceKategory().getNew("kate_preview")
    
    // case: .nomal
    PopupInputTodo(
        isPresented: $isShowing
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
    // case: .marked
    PopupInputTodo(
        templete: .marked,
        isPresented: $isShowing
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
    // case: kategory
    PopupInputTodo(
        kategory: kategory,
        isPresented: $isShowing
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
    // case: day
    PopupInputTodo(
        date: Date(),
        isPresented: $isShowing
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
    // case: week
    PopupInputTodo(
        week: 1,
        month: 1,
        year: 2026,
        isPresented: $isShowing
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
    // case: month
    PopupInputTodo(
        month: 1,
        year: 2026,
        isPresented: $isShowing
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
    // case: year
    PopupInputTodo(
        year: 2026,
        isPresented: $isShowing
    ) { result in
        NnLogger.log("(preview)Try to add new todo (result: \(result))", level: .debug)
    }
}
