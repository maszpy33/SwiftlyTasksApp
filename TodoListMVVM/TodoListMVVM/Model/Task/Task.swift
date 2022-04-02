//
//  Task.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import Foundation
import SwiftUI


struct TaskItem: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var title: String
    var details: String
    var category: String
    var taskEmoji: String
    var dueDate: Date
    var priority: String
    var status: Bool
    var hasDetails: Bool
    var uiDeleted: Bool
}

//enum Priority: String {
//
//    case normal = "normal"
//    case low = "low"
//    case medium = "medium"
//    case high = "high"
//
//    var title: String {
//        switch self {
//        case .low:
//            return "low"
//        case .medium:
//            return "medium"
//        case .high:
//            return "high"
//        default:
//            return "normal"
//        }
//    }
//
//    var color: Color {
//        switch self {
//        case .low:
//            return .blue
//        case .medium:
//            return .orange
//        case .high:
//            return .red
//        default:
//            return .gray
//        }
//    }
//}

//enum Priority: Int, Identifiable, CaseIterable {
//    var id: Int { rawValue }
//
//    case normal
//    case low
//    case medium
//    case high
//
//    var title: String {
//        switch self {
//        case .low:
//            return "low"
//        case .medium:
//            return "medium"
//        case .high:
//            return "high"
//        default:
//            return "normal"
//        }
//    }
//
//    var color: Color {
//        switch self {
//        case .low:
//            return .blue
//        case .medium:
//            return .orange
//        case .high:
//            return .red
//        default:
//            return .gray
//        }
//    }
//}

enum SortType: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case alphabetical
    case dueDate
    case priority
}
