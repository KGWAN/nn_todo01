//
//  TypePopup.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/26/26.
//

import Foundation

enum NnPopup: Identifiable {
    case selectKategory(onSelected: (Kategory) -> Void)
    case setKategory(target: Kategory?, onFinished: (Result) -> Void, onDelete: ((Result) -> Void)?)
    case viewDetailTodo(todo: Work, onFinished: (Result) -> Void)
    case selectTodoForMovingTo(destination: Kategory, predicate: NSPredicate, onUpdate: (Result) -> Void)
    case selectTodoForAddToPlanYear(to: Int, predicate: NSPredicate, onUpdate: (Result) -> Void)
    case selectTodoForAddToPlanMonth(to: Int, year: Int,predicate: NSPredicate, onUpdate: (Result) -> Void)
    case selectTodoForAddToPlanWeek(to: Int, month: Int, year: Int,predicate: NSPredicate, onUpdate: (Result) -> Void)
    case selectTodoForAddToPlanDay(to: Int, month: Int, year: Int,predicate: NSPredicate, onUpdate: (Result) -> Void)
    
    var id: String {
        switch self {
        case .selectKategory: return "selectKategory"
        case .setKategory: return "setKategory"
        case .viewDetailTodo(let todo, _): return "viewDetailTodo-\(todo.objectID.description)"
        case .selectTodoForMovingTo(let destination, _, _): return "selectTodo-kategory=\(destination)"
        case .selectTodoForAddToPlanYear(let year, _, _): return "selectTodo-year=\(year)"
        case .selectTodoForAddToPlanMonth(let month, let year, _, _): return "selectTodo-month=\(month)&year=\(year)"
        case .selectTodoForAddToPlanWeek(let week, let month, let year, _, _): return "selectTodo-week=\(week)&month=\(month)&year=\(year)"
        case .selectTodoForAddToPlanDay(let day, let month, let year, _, _): return "selectTodo-day=\(day)&month=\(month)&year=\(year)"
        }
    }
}
