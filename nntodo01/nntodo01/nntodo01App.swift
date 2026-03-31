//
//  nntodo01App.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/5/26.
//

import SwiftUI

@main
struct nntodo01App: App {
    // state
    @State private var isShowingMain = false
    @StateObject private var managerPopup = ManagerPopup()
    // constant
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isShowingMain {
                    ViewShell()
                } else {
                    ViewIntro {
                        isShowingMain = true
                    }
                }
                if let popup = managerPopup.popup {
                    renderPopup(popup)
                }
            }
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(managerPopup)
    }
    
    
    // viewBuilder
    @ViewBuilder
    private func renderPopup(_ popup: NnPopup) -> some View{
        switch popup {
        case .selectKategory(let onSelected):
            PopupSelectingKategory(onSelected: onSelected)
                .transition(.move(edge: .bottom))
        case .setKategory(let target, let onFinished, let onDelete):
            PopupInputKategory(origin: target, onFinish: onFinished, onDelete: onDelete)
        case .viewDetailTodo(let todo, let onFinished):
            PopupDetailTodo(todo, onFinish: onFinished)
                .transition(.move(edge: .trailing))
        case .selectTodoForMovingTo(destination: let destination, predicate: let predicate, onUpdate: let onUpdate):
            PopupSelectingTodo(destination: destination, predicate: predicate, onUpdate: onUpdate)
                .transition(.move(edge: .bottom))
        case .selectTodoForAddToPlanYear(to: let year, predicate: let predicate, onUpdate: let onUpdate):
            PopupSelectingTodo(to: year, predicate: predicate, onUpdate: onUpdate)
                .transition(.move(edge: .bottom))
        case .selectTodoForAddToPlanMonth(to: let month, year: let year, predicate: let predicate, onUpdate: let onUpdate):
            PopupSelectingTodo(to: month, year: year, predicate: predicate, onUpdate: onUpdate)
                .transition(.move(edge: .bottom))
        case .selectTodoForAddToPlanWeek(to: let week, month: let month, year: let year, predicate: let predicate, onUpdate: let onUpdate):
            PopupSelectingTodo(toWeek: week, month: month, year: year, predicate: predicate, onUpdate: onUpdate)
                .transition(.move(edge: .bottom))
        case .selectTodoForAddToPlanDay(to: let day, month: let month, year: let year, predicate: let predicate, onUpdate: let onUpdate):
            PopupSelectingTodo(toDay: day, month: month, year: year, predicate: predicate, onUpdate: onUpdate)
                .transition(.move(edge: .bottom))
        }
        
    }
}
