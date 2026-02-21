//
//  StorageManager.swift
//  TaskCat
//
//  Created by Tochishita Haruki on 2026/02/21.
//

import Foundation

class StorageManager {
    
    private static let key = "tasks_key"
    
    static func save(tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func load() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            return decoded
        }
        return []
    }
}
