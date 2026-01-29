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
    
    init() {
        container = NSPersistentContainer(name: "NnModel")
        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            if isPreview {
                description.type = NSInMemoryStoreType
            }
        }
        container.loadPersistentStores { storeDescription, error in
            NnLogger.log("CoreData load storeDescription: \(storeDescription)", level: .info)
            if let e = error {
                fatalError("CoreData load failed: \(e)")
            }
        }
    }
    
    // func
    func save() -> Result {
        do {
            try container.viewContext.save()
            return Result(code: "0000", msg: "성공")
        } catch {
            let nsError = error as NSError
            NnLogger.log("CoreData save failed: \(nsError)", level: .error)
            return Result(code: "9999", msg: "실패")
        }
    }
}
