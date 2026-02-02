//
//  ServiceWork.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData


class ServiceSubwork: NnService {
    
    func getNew(
        _ title: String,
        isDone: Bool = false
    ) -> Subwork {
        let subwork = Subwork(context: context)
        // auto
        subwork.id = UUID()
        subwork.createdDate = Date()
        // user's input
        subwork.title = title
        subwork.isDone = isDone
        
        return subwork
    }
    
    func create(
        _ title: String,
        isDone: Bool = false,
        parent: Work
    ) -> Result {
        let subwork = Subwork(context: context)
        // auto
        subwork.id = UUID()
        subwork.createdDate = Date()
        // user's input
        subwork.title = title
        subwork.isDone = isDone
        subwork.work = parent
        // save
        NnLogger.log("New Work was created. (work: \(subwork))", level: .info)
        return save()
    }
//    
//    func fetchAll() -> [Work] {
//        let request: NSFetchRequest<Work> = Work.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \Work.createdDate, ascending: true)]
//        
//        do {
//            return try context.fetch(request)
//        } catch {
//            fatalError("Fetching Failed: \(error)")
//        }
//    }
//    
//    func fetchOne(_ id: UUID) -> Work? {
//        let request: NSFetchRequest<Work> = Work.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        request.fetchLimit = 1
//        
//        do {
//            return try context.fetch(request).first
//        } catch {
//            fatalError("Fetching Failed: \(error)")
//        }
//    }
//    
//    func fetchList(_ predicate: NSPredicate?) -> [Work] {
//        let request: NSFetchRequest<Work> = Work.fetchRequest()
//        if predicate != nil {
//            request.predicate = predicate
//        }
//        
//        do {
//            return try context.fetch(request)
//        } catch {
//            fatalError("Fetching Failed: \(error)")
//        }
//    }
//    
//    func fetchList(_ predicate: NSPredicate, sort: [NSSortDescriptor]) -> [Work] {
//        let request: NSFetchRequest<Work> = Work.fetchRequest()
//        request.predicate = predicate
//        request.sortDescriptors = sort
//        
//        do {
//            return try context.fetch(request)
//        } catch {
//            fatalError("Fetching Failed: \(error)")
//        }
//    }
//    
    func update(_ new: Subwork) -> Result {
        // auto
        new.updatedDate = Date()
        // save
        return save()
    }
    
    func update(_ target: Subwork, key: String, value: Any) -> Result {
        switch key {
        case "isDone":
            if let newValue = value as? Bool { target.isDone = newValue }
        default:
            NnLogger.log("\(key) was not existed.")
            return Result(code: "9999", msg: "업데이트 실패")
        }
        
        return update(target)
    }
    
    func delete(_ target: Subwork) -> Result {
        context.delete(target)
        return save()
    }
}
