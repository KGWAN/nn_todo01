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
        case .selectTodo(destination: let destination, predicate: let predicate, onUpdate: let onUpdate):
            PopupSelectingTodo(destination: destination, predicate: predicate, onUpdate: onUpdate)
                .transition(.move(edge: .bottom))
        }
    }
}
