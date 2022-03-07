//
//  ViewModel.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import Foundation
import CoreData
import SwiftUI

class TaskViewModel: Identifiable, ObservableObject {
    
//    @Published var tasks: [TaskItem] = [
//        //        TaskItem(title: "Publish an articel"),
//        //        TaskItem(title: "Finish 100DoSUI"),
//        //        TaskItem(title: "Understand CoreData")
//        TaskItem(title: "Publish An Article", details: "@Medium", category: "private", dueDate: Date(timeIntervalSinceReferenceDate:1619231231.0), priority: "low", status: false),
//        TaskItem(title: "Buy Some Foods", details: "BBinstant", category: "programming", dueDate: Date(timeIntervalSinceReferenceDate:1621231231.0), priority: "high", status: false),
//        TaskItem(title: "Launch the App", details: "App Store", category: "art", dueDate: Date(), priority: "medium", status: false),
//        TaskItem(title: "Walk Around", details: "Garden", category: "university", dueDate: Date(), priority: "low", status: false)
//    ]
    
    @Published var tasks: [TaskItem] = [] {
        didSet {
            saveData()
        }
    }
    
//    @Published var sortType: SortType = .priority
//    @Published var isPresented = false
//    @Published var searched = ""
    
    // Settings choice arrays for adding or edditing a task
    let taskCategoryOptions = ["private","computer science", "university", "art", "sport", "other"]
    let taskCategorySymboleOptions = ["swift", "pencil", "clock", "alarm", "heart.circle", "brain.head.profile", "bed.double.circle", "star","keyboard", "laptopcomputer", "iphone", "ipad", "applewatch", "airpodspro", "gamecontroller.fill", "airplane", "car", "bus", "tram", "figure.walk", "person", "person.3", "globe.europe.africa.fill", "flame", "drop", "bolt", "pawprint", "leaf", "message", "quote.bubble", "cart", "giftcard.fill", "creditcard", "eurosign.circle", "x.squareroot", "number.square"]
    let taskPriorityOptions = ["non", "low", "medium", "high"]
    
    let taskOverdueLimit = -3
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    // DATEFORMATTER
    let dateFormatter = DateFormatter()
    
    // Core Data stuff
    let container: NSPersistentContainer
    
    @Published var savedTasks: [TaskItemEntity] = []
    
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
    }
    
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
    
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchTaskData()
        } catch {
            print("Error saving. \(error)")
        }
    }
    
    
    func saveTaskEntitys(title: String, details: String, category: String, categorySymbol: String, priority: String, dueDate: Date, status: Bool, uiDeleted: Bool) {
        let newTask = TaskItemEntity(context: container.viewContext)
        newTask.title = title
        newTask.details = details
        newTask.category = category
        newTask.categorySymbol = categorySymbol
        newTask.priority = priority
        newTask.dueDate = dueDate
        newTask.status = status
        newTask.uiDeleted = uiDeleted
        saveData()
    }
    
    func deleteTaskEntity(with taskID: ObjectIdentifier) {
        print("______________")
        print("DELETED TASK \(taskID)")
        print("______________")
        guard let entity = savedTasks.first(where: { $0.id == taskID }) else { return }
//        guard let index = savedTasks.firstIndex(where: { $0.id == taskID }) else { return }
//        let entity = savedTasks[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func updateTaskEntity(taskEntity: TaskItemEntity, newTitle: String, newDetails: String, newCategory: String, newCategorySymbol: String, newPriority: String, newDueDate: Date, newStatus: Bool, newUIDelete: Bool) {
        taskEntity.title = newTitle
        taskEntity.details = newDetails
        taskEntity.category = newCategory
        taskEntity.categorySymbol = newCategorySymbol
        taskEntity.priority = newPriority
        taskEntity.dueDate = newDueDate
        taskEntity.status = newStatus
        taskEntity.uiDeleted = newUIDelete
        saveData()
    }
    
    func updateTaskEntityRandomPriority(taskEntity: TaskItemEntity) {
        let newPriority = taskPriorityOptions[Int.random(in: 0...taskPriorityOptions.count)]
        taskEntity.priority = newPriority
        saveData()
    }
    
    func updateTaskStatus(taskEntity: TaskItemEntity) {
        taskEntity.status.toggle()
        saveData()
    }
    
    func updateUIDeleted(taskEntity: TaskItemEntity) {
        taskEntity.uiDeleted.toggle()
        saveData()
    }
    
    func styleForPriority(taskPriority: String) -> Color {
        //        let priority = Priority(rawValue: value)
        switch taskPriority {
        case "low":
            return Color.blue
        case "medium":
            return Color.orange
        case "high":
            return Color.red
        default:
            return Color.gray
        }
    }
    
    func daysLeft(dueDate: Date) -> Int {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let today = dateFormatter.string(from: Date())
        let dueDateFormatted = dateFormatter.string(from: dueDate)
        
        guard dueDateFormatted != today else {
            return 0
        }
        
        let taskDueDate = Calendar.current.dateComponents([.day, .month, .year], from: dueDate)
        
        let taskDueDateComponents = DateComponents(calendar: Calendar.current, year: taskDueDate.year!, month: taskDueDate.month!, day: taskDueDate.day!).date!
        
        let diffs = Calendar.current.dateComponents([.day], from: Date(), to: taskDueDateComponents)
        let daysUntil = diffs.day
        
        return daysUntil! + 1
    }
    
    
    //    func styleForPriority(taskPriority: String) -> Color {
    //        let priority = Priority(rawValue: taskPriority)
    //
    //        switch priority {
    //        case .low:
    //            return Color.blue
    //        case .medium:
    //            return Color.orange
    //        case .high:
    //            return Color.red
    //        default:
    //            return Color.black
    //        }
    //    }
    
    
    //    func addTask(task: TaskItem) {
    //        tasks.append(task)
    //    }
    //
    //    func removeTask(indexAt: IndexSet) {
    //        tasks.remove(atOffsets: indexAt)
    //    }
    
    //    func sort() {
    //        switch sortType {
    //        case .alphabetical:
    //            tasks.sort(by: { $0.title < $1.title })
    //        case .dueDate:
    //            tasks.sort(by: { $0.dueDate < $1.dueDate })
    //        case .priority:
    //            tasks.sort(by: { $0.priority.rawValue > $1.priority.rawValue })
    //        }
    //    }
}
