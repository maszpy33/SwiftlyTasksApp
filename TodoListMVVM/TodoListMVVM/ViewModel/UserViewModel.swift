//
//  ImageViewModel.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import Foundation
import CoreData
import SwiftUI


final class UserViewModel: DataClassViewModel {
    
    @Published var userOne = User(userName: "DefaultName", taskOverdueLimit: 3, themeColor: "yellow", profileImage: UIImage(named: "JokerCodeProfile")!, timerDuration: 25, timerBreakDuration: 5, timerRounds: 5)
    
    let secondaryAccentColor = Color("SecondaryAccentColor")

    
    // ***********************************
    // ***** USERVIEWMODEL FUNCTIONS *****
    // ***********************************
    
    func saveUserData() {
        do {
            try container.viewContext.save()
            fetchUserData()
        } catch {
            print("Error saving. \(error)")
        }
    }
    
    func updateUserEntity(userName: String, taskOverdueLimit: Int16, themeColor: String, duration: Int32, breakDuration: Int16, rounds: Int16) {
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
    
    func updateTimerSettings(duration: Int32, breakDuration: Int16, rounds: Int16) {
        
    }
}
