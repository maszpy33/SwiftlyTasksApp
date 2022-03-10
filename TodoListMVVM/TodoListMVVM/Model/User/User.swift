//
//  User.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import Foundation
import UIKit


struct User: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let userName: String
    let taskOverdueLimit: Int16
    let themeColor: String
    let profileImage: UIImage
    let timerDuration: Int16
    let timerBreakDuration: Int16
    let timerRounds: Int16
    
    // Timer
    
    // just cast the profileImage variable name when it's saved to core data.
    // here it should be fine to cast it as UIImage
}
