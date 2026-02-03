//
//  ServiceWork.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData


class ServiceWork: NnService {
    
    func getNewWork(
        _ title: String,
        isDone: Bool = false,
        isMarked: Bool = false
    ) -> Work {
        let work = Work(context: context)
        // auto
        work.id = UUID()
        work.createdDate = Date()
        // user's input
        work.title = title
        work.isDone = isDone
        work.isMarked = isMarked
        
        return work
    }   
    
    func create(
        _ title: String,
        isDone: Bool = false,
        isMarked: Bool = false,
        isToday: Bool = false,
        kategory: Kategory? = nil
    ) -> Result {
        let work = Work(context: context)
        // auto
        work.id = UUID()
        work.createdDate = Date()
        // user's input
        work.title = title
        work.isDone = isDone
        work.isMarked = isMarked
        work.isToday = isToday
        work.kategory = kategory
        // save
        NnLogger.log("New Work was created. (work: \(work))", level: .info)
        return save()
    }
    
    func fetchAll() -> [Work] {
        let request: NSFetchRequest<Work> = Work.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Work.createdDate, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func fetchOne(_ id: UUID) -> Work? {
        let request: NSFetchRequest<Work> = Work.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func fetchList(_ predicate: NSPredicate?) -> [Work] {
        let request: NSFetchRequest<Work> = Work.fetchRequest()
        if predicate != nil {
            request.predicate = predicate
        }
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func fetchList(_ predicate: NSPredicate, sort: [NSSortDescriptor]) -> [Work] {
        let request: NSFetchRequest<Work> = Work.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sort
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func update(_ newWork: Work) -> Result {
        // auto
        newWork.updatedDate = Date()
        // save
        return save()
    }
    
    func update(_ work: Work, key: String, value: Any) -> Result {
        switch key {
        case "isDone":
            if let newValue = value as? Bool { work.isDone = newValue }
        case "isMarked":
            if let newValue = value as? Bool { work.isMarked = newValue }
        case "isToday":
            if let newValue = value as? Bool { work.isToday = newValue }
        case "subworks":
            if let newValue = value as? [Subwork] {
                for i in newValue.indices {
                    newValue[i].sortNum = "\(i)"
                }
            }
        default:
            NnLogger.log("\(key) was not existed.")
            return Result(code: "9999", msg: "업데이트 실패")
        }
        
        return update(work)
    }
    
    func delete(_ work: Work) -> Result {
        context.delete(work)
        return save()
    }
    
    func addChild(_ name: String, isDone: Bool = false, target: Work) -> Result  {
        target.addToSubworks(ServiceSubwork().getNew(name, isDone: isDone, parent: target))
        NnLogger.log("New subwork added. (subwork's count: \(target.subworks?.count ?? 0))", level: .info)
        return save()
    }
    
    func removeChild(_ subwork: Subwork, target: Work) -> Result {
        target.removeFromSubworks(subwork)
        return save()
    }
    
    func getCnt(_ predicate: NSPredicate? = nil) -> Int{
        return fetchList(predicate).count
    }
}
