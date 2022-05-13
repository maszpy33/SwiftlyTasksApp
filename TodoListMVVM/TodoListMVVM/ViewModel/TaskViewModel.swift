//
//  ViewModel.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import Foundation
import CoreData
import SwiftUI


final class TaskViewModel: DataClassViewModel {
    
    @Published var sortType: SortType = .priority
    
    // DATEFORMATTER
    let dateFormatter = DateFormatter()
    
    // FIXME: Make default time changable
    let defaultTime = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
    
    // Settings choice arrays for adding or edditing a task
    let taskCategoryOptions = ["private","computer science", "university", "art", "sport", "other"]
    let taskCategorySymboleOptions = ["swift", "pencil", "clock", "alarm", "heart.circle", "brain.head.profile", "bed.double.circle", "star","keyboard", "laptopcomputer", "iphone", "ipad", "applewatch", "airpodspro", "gamecontroller.fill", "airplane", "car", "bus", "tram", "figure.walk", "person", "person.3", "globe.europe.africa.fill", "flame", "drop", "bolt", "pawprint", "leaf", "message", "quote.bubble", "cart", "giftcard.fill", "creditcard", "eurosign.circle", "x.squareroot", "number.square"]
    let taskPriorityOptions = ["non", "low", "medium", "high"]
    let taskOverdueLimit = -3
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    // SEARCHBAR string variable
    @Published var searchText = ""
    
    // SEARCHBAR savedTask wrapper
    var searchableTasks: [TaskItemEntity] {
        print(searchText)
        return searchText == "" ? savedTasks : savedTasks.filter {
            $0.wTitle.lowercased().contains(searchText.lowercased())
        }
    }
    
    // ***********************************
    // ***** TASKVIEWMODEL FUNCTIONS *****
    // ***********************************
    
    func saveTaskData() {
        do {
            try container.viewContext.save()
            fetchTaskData()
        } catch {
            print("Error saving. \(error)")
        }
    }
    
    
    func saveTaskEntitys(title: String, details: String, category: String, taskEmoji: String, priority: String, dueDate: Date, status: Bool, hasDetails: Bool, uiDeleted: Bool) {
        let newTask = TaskItemEntity(context: container.viewContext)
        newTask.title = title
        newTask.details = details
        newTask.category = category
        newTask.taskEmoji = taskEmoji
        newTask.priority = priority
        newTask.dueDate = dueDate
        newTask.status = status
        newTask.hasDetails = hasDetails
        newTask.uiDeleted = uiDeleted
        saveTaskData()
    }
    
    func deleteTaskEntity(with taskID: ObjectIdentifier) {
        print("______________")
        print("DELETED TASK \(taskID)")
        print("______________")
        guard let entity = savedTasks.first(where: { $0.id == taskID }) else { return }
//        guard let index = savedTasks.firstIndex(where: { $0.id == taskID }) else { return }
//        let entity = savedTasks[index]
        container.viewContext.delete(entity)
        saveTaskData()
    }
    
    func updateTaskEntity(taskEntity: TaskItemEntity, newTitle: String, newDetails: String, newCategory: String, newTaskEmoji: String, newPriority: String, newDueDate: Date, newStatus: Bool, newHasDetails: Bool, newUIDelete: Bool) {
        taskEntity.title = newTitle
        taskEntity.details = newDetails
        taskEntity.category = newCategory
        taskEntity.taskEmoji = newTaskEmoji
        taskEntity.priority = newPriority
        taskEntity.dueDate = newDueDate
        taskEntity.status = newStatus
        taskEntity.hasDetails = newHasDetails
        taskEntity.uiDeleted = newUIDelete
        saveTaskData()
    }
    
    func updateTaskEntityRandomPriority(taskEntity: TaskItemEntity) {
        let newPriority = taskPriorityOptions[Int.random(in: 0...taskPriorityOptions.count)]
        taskEntity.priority = newPriority
        saveTaskData()
    }
    
    func updateTaskStatus(taskEntity: TaskItemEntity) {
        taskEntity.status.toggle()
        saveTaskData()
    }
    
    func updateUIDeleted(taskEntity: TaskItemEntity) {
        taskEntity.uiDeleted.toggle()
        saveTaskData()
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
    
//    func daysLeft(dueDate: Date) -> (Int, String) {
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
//        let today = dateFormatter.string(from: Date())
//        let dueDateFormatted = dateFormatter.string(from: dueDate)
//        
//        print(dueDateFormatted)
//        
//        guard dueDateFormatted != today else {
//            return (0, "Days")
//        }
//        
//        let taskDueDate = Calendar.current.dateComponents([.day, .month, .year], from: dueDate)
//        
//        let taskDueDateComponents = DateComponents(calendar: Calendar.current, year: taskDueDate.year!, month: taskDueDate.month!, day: taskDueDate.day!).date!
//        
//        let diffs = Calendar.current.dateComponents([.day], from: Date(), to: taskDueDateComponents)
//        
//        let daysUntil = diffs.day ?? 0 + 1
//        
//        guard daysUntil != 1 else {
//            return (daysUntil, "Day")
//        }
//                    
//        return (daysUntil, "Days")
//    }
    
    // calculate how many days or hours are left till task
    func daysHoursLeft(dueDate: Date, hasTime: Bool) -> (Int, String) {
        
        // check if task has due day time else default time 10am
        var newDueDate: Date {
            if !hasTime {
                let newDueDate = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: dueDate)!
                return newDueDate
            } else {
                let newDueDate = dueDate
                return newDueDate
            }
        }
        

        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dueDateFormatted = dateFormatter.string(from: newDueDate)
        let today = dateFormatter.string(from: Date())
        
        
        guard dueDateFormatted != today else {
            return (0, "Hours")
        }
        
        let taskDueDate = Calendar.current.dateComponents([.hour, .day, .month, .year], from: newDueDate)
        
        let taskDueDateComponents = DateComponents(calendar: Calendar.current, year: taskDueDate.year!, month: taskDueDate.month!, day: taskDueDate.day!, hour: taskDueDate.hour!).date!
        
        let diffs = Calendar.current.dateComponents([.day, .hour], from: Date(), to: taskDueDateComponents)
        
//        print(diffs)
        
        let daysUntil = (diffs.day ?? 0)
        let hoursLeft = (diffs.hour ?? 0)
        
        // if days higher than 1 return days
        guard daysUntil < 2 else {
            return (daysUntil, "Days")
        }
        
        // if days is 1 return days with Day string
        guard daysUntil != 1 else {
            return (daysUntil, "Day")
        }
        
        // if hours != 1 return hours with hour string
        guard hoursLeft < 0 else {
            return (hoursLeft, "hour")
        }
        
        // else return hours left
        return (hoursLeft, "Hours")
    }
    
    func returnDaysAndHours(dueDate: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
//        let today = dateFormatter.string(from: Date())
//        let dueDateFormatted = dateFormatter.string(from: dueDate)
        
        let taskDueDate = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: dueDate)
        
        let taskDueDateComponents = DateComponents(calendar: Calendar.current, year: taskDueDate.year!, month: taskDueDate.month!, day: taskDueDate.day!, hour: taskDueDate.hour!, minute: taskDueDate.minute!).date!
        
        let diffs = Calendar.current.dateComponents([.day, .hour], from: Date(), to: taskDueDateComponents)
        
        let daysUntil = diffs.day ?? 0 + 1
        let hoursLeft = diffs.hour ?? 0 + 1
        let minutesLeft = diffs.minute ?? 0 + 1
        
        let resultCountdown = "\(daysUntil)d \(hoursLeft)h \(minutesLeft)m"
        
        return resultCountdown
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
    
//        func sort() {
//            switch sortType {
//            case .alphabetical:
//                tasks.sort(by: { $0.title < $1.title })
//            case .dueDate:
//                tasks.sort(by: { $0.dueDate < $1.dueDate })
//            case .priority:
//                tasks.sort(by: { $0.priority > $1.priority })
//            }
//        }
}
