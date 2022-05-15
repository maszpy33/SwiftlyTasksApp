//
//  KeyboardEnum.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 15.05.22.
//

import Foundation


// DISMISS KEYBOARD VARIABLES
enum Field: Int, CaseIterable {
    // ADD & EDIT TASK
    case taskTitleTextField
    case taskDetailsTextField
    case taskEmoji
    
    // TIMER SETTINGS
    case newDuration
    case newBreakDuration
    case newRounds
    
    // USER SETTINGS
    case newUserName
    case newTaskOverdueLimit
}
