//
//  DataClassViewModel.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 25.03.22.
//

import Foundation
import CoreData
import SwiftUI


class DataClassViewModel: Identifiable, ObservableObject {

    // ***************************
    // ***** SHAREDVIEWMODEL *****
    // ***************************
    
    @Published var savedTasks: [TaskItemEntity] = []
    @Published var savedUserData: [UserEntity] = []
    
    // COREDATA STUFF
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TodoListModel_CoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
        fetchTaskData()
        fetchUserData()
    }
    
    // *************************
    // ***** TASKVIEWMODEL *****
    // *************************
    
    func fetchTaskData() {
        let request = NSFetchRequest<TaskItemEntity>(entityName: "TaskItemEntity")
        let sortStatus = NSSortDescriptor(key: "status", ascending: true)
        let sortDueDate = NSSortDescriptor(key: "dueDate", ascending: true)
        let sortPriority = NSSortDescriptor(key: "priority", ascending: true)
        request.sortDescriptors = [sortStatus, sortDueDate, sortPriority]
        //        @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "status", ascending: true), NSSortDescriptor(key: "dueDate", ascending: true)]) private var allTasks: FetchedResults<Task>
        
        do {
            savedTasks = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    // *************************
    // ***** USERVIEWMODEL *****
    // *************************
    
    func fetchUserData() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")

        do {
            savedUserData = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    
}
