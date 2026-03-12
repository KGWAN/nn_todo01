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
    // constant
    let persistenceController = PersistenceController.shared
    @State private var state = NnState()
    
    var body: some Scene {
        WindowGroup {
            if isShowingMain {
                ViewShell()
            } else {
                ViewIntro {
                    isShowingMain = true
                }
            }
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environment(state)
    }
}
