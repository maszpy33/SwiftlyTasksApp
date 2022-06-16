//
//  TaskItemEntity+CoreDataProperties.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 13.06.22.
//
//

import Foundation
import CoreData


extension TaskItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItemEntity> {
        return NSFetchRequest<TaskItemEntity>(entityName: "TaskItemEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var details: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var hasAlert: Bool
    @NSManaged public var hasDetails: Bool
    @NSManaged public var priority: String?
    @NSManaged public var status: Bool
    @NSManaged public var taskEmoji: String?
    @NSManaged public var title: String?
    @NSManaged public var uiDeleted: Bool
    @NSManaged public var ofList: ListItemEntity?

    
    public var wTitle: String {
        title ?? "No Title"
    }
    public var wTaskEmoji: String {
        taskEmoji ?? "🤷🏻‍♂️"
    }
    public var wDetails: String {
        details ?? "no details"
    }
    public var wCategory: String {
        category ?? "private"
    }
    public var wDueDate: Date {
        dueDate ?? Date()
    }
    public var wPriority: String {
        priority ?? "non"
    }
}

extension TaskItemEntity : Identifiable {

}
