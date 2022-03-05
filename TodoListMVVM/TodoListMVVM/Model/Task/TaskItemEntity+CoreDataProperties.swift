//
//  TaskItemEntity+CoreDataProperties.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//
//

import Foundation
import CoreData


extension TaskItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItemEntity> {
        return NSFetchRequest<TaskItemEntity>(entityName: "TaskItemEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var categorySymbol: String?
    @NSManaged public var details: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var priority: String?
    @NSManaged public var status: Bool
    @NSManaged public var title: String?
    @NSManaged public var uiDeleted: Bool
    @NSManaged public var profileImage: Data?

}

extension TaskItemEntity : Identifiable {

}
