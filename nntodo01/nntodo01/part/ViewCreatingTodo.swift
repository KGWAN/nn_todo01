//
//  ViewCreatingTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/11/26.
//

import SwiftUI

struct ViewCreatingTodo: View {
    // init
    init(
        templete: Templete = .normal,
        parent: Work? = nil,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.templete = templete
        self.parent = parent
        // dummy
        self.kategory = nil
        self.typePlan = nil
        self.year = 0
        self.month = 0
        self.week = 0
        self.day = 0
    }
    init(
        kategory: Kategory,
        parent: Work? = nil,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.kategory = kategory
        self.parent = parent
        // dummy
        self.templete = .normal
        self.typePlan = nil
        self.year = 0
        self.month = 0
        self.week = 0
        self.day = 0
    }
    init(
        year: Int,
        parent: Work? = nil,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.typePlan = .year
        self.year = year
        self.parent = parent
        // dummy
        self.templete = .normal
        self.kategory = nil
        self.month = 0
        self.week = 0
        self.day = 0
    }
    init(
        month: Int,
        year: Int,
        parent: Work? = nil,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.typePlan = .month
        self.month = month
        self.year = year
        self.parent = parent
        // dummy
        self.templete = .normal
        self.kategory = nil
        self.week = 0
        self.day = 0
    }
    init(
        week: Int,
        month: Int,
        year: Int,
        parent: Work? = nil,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.typePlan = .week
        self.week = week
        self.month = month
        self.year = year
        self.parent = parent
        // dummy
        self.templete = .normal
        self.kategory = nil
        self.day = 0
    }
    init(
        day: Int,
        month: Int,
        year: Int,
        parent: Work? = nil,
        isPresented: Binding<Bool>,
        onFinish: @escaping (Result) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
        self.typePlan = .day
        self.day = day
        self.month = month
        self.year = year
        self.parent = parent
        // dummy
        self.templete = .normal
        self.kategory = nil
        self.week = 0
    }
    // constant ---------------------------------
    private let service: ServiceWork = ServiceWork()
    // callback
    private let onFinish: (Result) -> Void
    // case: templete
    // .normal > default
    // .marked > 별표
    private let templete: Templete
    // case: kategory
    private let kategory: Kategory?
    // case: plan
    private let typePlan: TypePlan?
    private let year: Int?
    private let month: Int?
    private let week: Int?
    private let day: Int?
    // case: 부모가 있는 경우
    private let parent: Work?
    // -------------------------------------------
    // state -------------------------------------
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @FocusState private var isFocusingOnField: Bool
    // -------------------------------------------
    
    
    var body: some View {
        // 작성 부분
        HStack {
            BtnCheckImg("btnDone", isChecked: Binding(get: { false }, set: { _ in }))
                .frame(width: 25, height: 25)
                .disabled(true)
            TextFieldTitle(placeholder: "작성할 일의 이름을 입력하세요.", text: $name)
                .focused($isFocusingOnField)
                .onChange(of: isFocusingOnField) { _, new in
                    isPresented = new
                }
                .submitLabel(.done)
                .onSubmit {
                    // 생성
                    if !name.isEmpty {
                        onFinish(create(name))
                    }
                    // 이름 초기화
                    name = ""
                    // 사라지기
                    isFocusingOnField = false
                    isPresented = false
                }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.3))
        .border(Color.gray)
        .onAppear {
            isFocusingOnField = true
        }
    }
    
    // 할 일 생성 함수
    private func create(_ title: String) -> Result {
        if templete == .marked {
            return service.create(title, isMarked: true, parent: parent)
        } else if kategory != nil {
            return service.create(title, kategory: kategory, parent: parent)
        } else if typePlan == .day {
            return service.create(title, planedDay: day!, planedMonth: month!, planedYear: year!, parent: parent)
        } else if typePlan == .week {
            return service.create(title, planedWeek: week!, planedMonth: month!, planedYear: year!, parent: parent)
        } else if typePlan == .month {
            return service.create(title, planedMonth: month!, planedYear: year!, parent: parent)
        } else if typePlan == .year {
            return service.create(title, planedYear: year!, parent: parent)
        }
        return service.create(title, parent: parent)
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
    
    ViewCreatingTodo(isPresented: $isPresented) { result in
        print(result)
    }
}
