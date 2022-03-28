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
    
    @Published var userOne = User(userName: "DefaultName", taskOverdueLimit: 3, themeColor: "yellow", profileImage: UIImage(named: "JokerCodeProfile")!, timerDuration: 25, timerBreakDuration: 5, timerRounds: 5)
    
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
        fetchUserData()
    }

    func fetchUserData() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")

        do {
            savedUserData = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    func saveUserData() {
        do {
            try container.viewContext.save()
            fetchUserData()
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
            saveUserData()
        }
        let updatedUser = UserEntity(context: container.viewContext)
        updatedUser.userName = userName
        updatedUser.taskOverdueLimit = taskOverdueLimit
        updatedUser.themeColor = themeColor
        updatedUser.timerDuration = duration
        updatedUser.timerBreakDuration = breakDuration
        updatedUser.timerRounds = rounds
        
//        updatedUser.profileImage = pickedImage
        saveUserData()
    }
    
    func updateTimerSettings(duration: Int16, breakDuration: Int16, rounds: Int16) {
        
    }
}
