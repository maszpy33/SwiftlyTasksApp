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
    
    // SECONDARY COLOR PLATE
    let secondaryAccentColor = Color("SecondaryAccentColor")
    // ColorPlate MAIN COLOR
    let accentColorOne = Color("AccentColorOne")
    let accentColorTwo = Color("AccentColorTwo")
//    let accentColorThree = Color("AccentColorThree")
    let accentColorFour = Color("AccentColorFour")
    let accentColorFive = Color("AccentColorFive")
    let accentColorSix = Color("AccentColorSix")
    let accentColorSeven = Color("AccentColorSeven")

    // COLOR ARRAY
    let colorPlate = ["purple", "blue", "green", "red", "yellow", "orange"]
    
    // FIXME: Make default time changable
    let defaultTime = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
    
    override init() {
        super.init()
        // initUser when app is first started
        if savedUserData.isEmpty {
            updateUserEntity(userName: "UserName", taskOverdueLimit: 14, themeColor: "blue", duration: 25, breakDuration: 5, rounds: 8, switchUITheme: false)
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
    
    func updateUserEntity(userName: String, taskOverdueLimit: Int16, themeColor: String, duration: Int32, breakDuration: Int32, rounds: Int32, switchUITheme: Bool) {
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
        updatedUser.switchUITheme = switchUITheme
        
//        updatedUser.profileImage = pickedImage
        saveUserData()
    }
    
    func updateTimerSettings(duration: Int32, breakDuration: Int32, rounds: Int32) {
        
    }
    
    // return color function
    func colorTheme(colorPick: String) -> Color {
        switch colorPick {
        case "purple":
            return accentColorOne
        case "blue":
            return accentColorTwo
        case "green":
            return accentColorSix
        case "red":
            return accentColorFour
        case "yellow":
            return accentColorFive
        case "orange":
            return accentColorSeven
        default:
            return .accentColor
        }
    }
}
