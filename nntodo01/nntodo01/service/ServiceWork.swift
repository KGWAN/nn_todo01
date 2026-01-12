//
//  ServiceWork.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData


class ServiceWork {
    // init
    private let context: NSManagedObjectContext
    
    init() {
        context = persistenceController.container.viewContext
    }
    
    // constant
    private let persistenceController = PersistenceController.shared
    
    
    // func
    func save() {
        persistenceController.save()
    }
    
    func create(_ title: String, isDone: Bool = false) {
        let work = Work(context: context)
        // auto
        work.id = UUID()
        work.createdDate = Date()
        // user's input
        work.title = title
        work.isDone = isDone
        // save
        save()
    }
    
    func fetchAll() -> [Work] {
        let request: NSFetchRequest<Work> = Work.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func fetchOne(_ id: UUID) -> Work? {
        let request: NSFetchRequest<Work> = Work.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func update(_ work: Work, title: String, isDone: Bool = false) {
        // auto
        work.updatedDate = Date()
        // user's input
        work.title = title
        work.isDone = isDone
        // save
        save()
    }
    
    func delete(_ work: Work) {
        context.delete(work)
        save()
    }
}
