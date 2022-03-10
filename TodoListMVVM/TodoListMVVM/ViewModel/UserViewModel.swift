//
//  ImageViewModel.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import Foundation
import CoreData
import SwiftUI


class UserViewModel: Identifiable, ObservableObject {
    
    @Published var user = User(userName: "DefaultName", taskOverdueLimit: 3, themeColor: "yellow", profileImage: UIImage(named: "JokerCodeProfile")!, timerDuration: 25, timerBreakDuration: 5, timerRounds: 5) {
        didSet {
            saveData()
        }
    }
    
    let secondaryAccentColor = Color("SecondaryAccentColor")

    // Core Data stuff
    let container: NSPersistentContainer

    @Published var savedUserData: [UserEntity] = []
    
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
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
//        let sortName = NSSortDescriptor(key: "userName", ascending: true)
//        let sortDueDate = NSSortDescriptor(key: "dueDate", ascending: true)
//        request.sortDescriptors = sortName
        //        @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "status", ascending: true), NSSortDescriptor(key: "dueDate", ascending: true)]) private var allTasks: FetchedResults<Task>

        do {
            savedUserData = try container.viewContext.fetch(request)
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
    
    func updateUserEntity(userName: String, taskOverdueLimit: Int16, themeColor: String, duration: Int16, breakDuration: Int16, rounds: Int16) {
//        let pickedImage = profileImage.jpegData(compressionQuality: 0.70)
        
        if !savedUserData.isEmpty {
            for userData in savedUserData {
                container.viewContext.delete(userData)
            }
            saveData()
        }
        let updatedUser = UserEntity(context: container.viewContext)
        updatedUser.userName = userName
        updatedUser.taskOverdueLimit = taskOverdueLimit
        updatedUser.themeColor = themeColor
        updatedUser.timerDuration = duration
        updatedUser.timerBreakDuration = breakDuration
        updatedUser.timerRounds = rounds
        
//        updatedUser.profileImage = pickedImage
        saveData()
    }
    
    func updateTimerSettings(duration: Int16, breakDuration: Int16, rounds: Int16) {
        
    }
}
