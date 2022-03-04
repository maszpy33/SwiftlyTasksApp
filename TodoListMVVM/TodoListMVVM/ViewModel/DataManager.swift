//
//  DataManager.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import Foundation
import CoreData


class DataManager {
    let persistentContainer: NSPersistentContainer
     
    // singelton variable for the entire app
    static let shared: DataManager = DataManager()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TodoListModel_CoreData")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
    }
}
