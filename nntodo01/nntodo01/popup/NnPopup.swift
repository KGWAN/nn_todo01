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
    case selectTodo(destination: Kategory, predicate: NSPredicate, onUpdate: (Result) -> Void)
    
    var id: String {
        switch self {
        case .selectKategory: return "selectKategory"
        case .setKategory: return "setKategory"
        case .viewDetailTodo(let todo, _): return "viewDetailTodo-\(todo.objectID.description)"
        case .selectTodo: return "selectTodo"
        }
    }
}
