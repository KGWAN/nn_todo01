//
//  ServiceUserPhoto.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/4/26.
//

import Foundation
import CoreData

class ServiceUserPhoto: NnService {
    func getNew(
        _ path: String,
    ) -> UserPhoto {
        let new = UserPhoto(context: context)
        // auto
        new.id = UUID()
        new.createdDate = Date()
        // user's input
        new.path = path
        
        return new
    }
    
    func insert(
        _ path: String,
    ) -> Result {
        let new = UserPhoto(context: context)
        // auto
        new.id = UUID()
        new.createdDate = Date()
        // user's input
        new.path = path
        // save
        NnLogger.log("New user photo was created. (user photo: \(new))", level: .info)
        return save()
    }
    
    func fetchAll() -> [UserPhoto] {
        let request: NSFetchRequest<UserPhoto> = UserPhoto.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserPhoto.createdDate, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
}
