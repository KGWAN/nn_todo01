//
//  ServiceTodo.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/7/26.
//

import Foundation

class ServiceTodo {
    private let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    private let todoStorageKey = "TODO_STORAGE_KEY"
    
    func create(_ title: String, isDone: Bool = false) -> Todo {
         return Todo(title, isDone: isDone)
    }
    
    func save(_ list: [Todo]) {
        if isPreview { return }
        
        do {
            let data = try JSONEncoder().encode(list)
            UserDefaults.standard.set(data, forKey: todoStorageKey)
            
        } catch {
            NnLogger.log("It's failed to save todo list: \(error)", level: .error)
        }
    }
    
    func loadAll() -> [Todo] {
        guard let data = UserDefaults.standard.data(forKey: todoStorageKey) else {
            NnLogger.log("It's failed to get todo data for UserDefaults", level: .error)
            return []
        }
        
        do {
            let list = try JSONDecoder().decode([Todo].self, from: data)
            NnLogger.log("Todo list loaded. (cnt : \(list.count))", level: .info)
            return list
        } catch {
            NnLogger.log("It's failed to load todo list: \(error)", level: .error)
            return []
        }
    }
}
