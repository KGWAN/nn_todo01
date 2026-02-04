//
//  ServiceWork.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData


class ServiceKategory: NnService {
    func getNew(
        _ title: String,
        markType: String = "color",
        color: String = ColorMarkKategory.allCases[0].rawValue,
        photo: String = ColorMarkKategory.allCases[0].rawValue
    ) -> Kategory {
        let kate = Kategory(context: context)
        // auto
        kate.id = UUID()
        kate.createdDate = Date()
        // user's input
        kate.title = title
        kate.markType = markType
        kate.color = color
        kate.photo = photo
        
        return kate
    }
    
    func create(
        _ title: String,
        markType: String = "color",
        color: String = ColorMarkKategory.allCases[0].rawValue,
        photo: String = ColorMarkKategory.allCases[0].rawValue
    ) -> Result {
        let new = Kategory(context: context)
        // auto
        new.id = UUID()
        new.createdDate = Date()
        // user's input
        new.title = title
        new.markType = markType
        new.color = color
        new.photo = photo
        // log
        NnLogger.log("on insert kategory. : \(new)", level: .info)
        // save
        return save()
    }
    
    func fetchAll() -> [Kategory] {
        let request: NSFetchRequest<Kategory> = Kategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Kategory.createdDate, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func fetchOne(_ id: UUID) -> Kategory? {
        let request: NSFetchRequest<Kategory> = Kategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func fetchList(_ predicate: NSPredicate?) -> [Kategory] {
        let request: NSFetchRequest<Kategory> = Kategory.fetchRequest()
        if predicate != nil {
            request.predicate = predicate
        }
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func fetchList(_ predicate: NSPredicate, sort: [NSSortDescriptor]) -> [Kategory] {
        let request: NSFetchRequest<Kategory> = Kategory.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sort
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    
    func update(_ new: Kategory) -> Result {
        // auto
        new.updatedDate = Date()
        // log
        NnLogger.log("on updated kategory. : \(new)", level: .info)
        // save
        return save()
    }
    
    func delete(_ target: Kategory) -> Result {
        context.delete(target)
        return save()
    }
}
