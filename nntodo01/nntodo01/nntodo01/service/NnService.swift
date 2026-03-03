//
//  InterfaceService.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import Foundation
import CoreData

class NnService {
    // init
    let context: NSManagedObjectContext
    
    init() {
        context = persistenceController.container.viewContext
    }
    
    // constant
    private let persistenceController = PersistenceController.shared
    
    
    // func
    func save() -> Result {
        return persistenceController.save()
    }
}
