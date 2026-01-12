//
//  PersistenceController.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData

struct PersistenceController {
    // constant
    private let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    // static
    static let shared: PersistenceController = PersistenceController()
    
    // init
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NnModel")
        
        if isPreview {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        } else {
            if inMemory {
                container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
            }
            
            container.loadPersistentStores { _, error in
                if let e = error {
                    fatalError("CoreData load failed: \(e)")
                }
            }
        }
    }
    
    // func
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            NnLogger.log("CoreData save failed: \(nsError)", level: .error)
        }
    }
}
