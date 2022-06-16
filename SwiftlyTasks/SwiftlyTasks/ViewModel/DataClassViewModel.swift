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
    
    @Published var savedLists: [ListItemEntity] = []
    @Published var savedTasks: [TaskItemEntity] = []
    @Published var savedUserData: [UserEntity] = []
    
    // COREDATA STUFF
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
        fetchTaskData()
        fetchUserData()
        fetchListsData()
    }
    
    // *************************
    // ***** LISTVIEWMODEL *****
    // *************************
    
    func fetchListsData() {
        let request = NSFetchRequest<ListItemEntity>(entityName: "ListItemEntity")
        let sortTitle = NSSortDescriptor(key: "listTitle", ascending: true)
        request.sortDescriptors = [sortTitle]
        
        do {
            savedLists = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching lists. \(error)")
        }
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
            print("Error fetching tasks. \(error)")
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
