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
    
//    let initUserDefaults = User(userName: "DefaultName", taskOverdueLimit: 3, themeColor: "yellow", profileImage: UIImage(named: "JokerCodeProfile")!, timerDuration: 25, timerBreakDuration: 5, timerRounds: 5)
    
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    // FIXME: Make default time changable
    let defaultTime = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
    
    override init() {
        super.init()
        
        // initUser when app is first started
        if savedUserData.isEmpty {
            updateUserEntity(userName: "UserName", taskOverdueLimit: 14, themeColor: "blue", duration: 25, breakDuration: 5, rounds: 8)
        }
    }
    
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
