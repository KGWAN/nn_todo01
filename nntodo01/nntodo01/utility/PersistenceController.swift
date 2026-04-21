//
//  PersistenceController.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData
import WidgetKit

struct PersistenceController {
    // constant
    private let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    // static
    static let shared: PersistenceController = PersistenceController()
    
    // init
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "NnModel")
        // persistentStoreDescriptions 설정
        // 기본 생성
        container.persistentStoreDescriptions = [getDescription()]
        container.loadPersistentStores { storeDescription, error in
            NnLogger.log("CoreData load storeDescription: \(storeDescription)", level: .info)
            if let e = error {
                fatalError("CoreData load failed: \(e)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // func
    private func getDescription() -> NSPersistentStoreDescription {
        // 기본 생성
        let description = NSPersistentStoreDescription()
        if isPreview {
            description.type = NSInMemoryStoreType
        } else {
            // App Group 공유 폴더 URL 가져오기
            let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.olii")!
            // SQLite 파일 경로 생성
            let storeURL = groupURL.appendingPathComponent("olii.todo.sqlite")
            description.url = storeURL
        }
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        return description
    }
    
    func save() -> Result {
        do {
            try container.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
            return Result(code: "0000", msg: "성공")
        } catch {
            let nsError = error as NSError
            NnLogger.log("CoreData save failed: \(nsError)", level: .error)
            return Result(code: "9999", msg: "실패")
        }
    }
}
