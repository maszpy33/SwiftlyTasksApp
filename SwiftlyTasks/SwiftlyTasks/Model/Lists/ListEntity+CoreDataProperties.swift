//
//  ListEntity+CoreDataProperties.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 13.06.22.
//
//

import Foundation
import CoreData


extension ListItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItemEntity> {
        return NSFetchRequest<ListItemEntity>(entityName: "ListItemEntity")
    }

    @NSManaged public var listColor: String?
    @NSManaged public var listTitle: String?
    @NSManaged public var listIcon: String?
    @NSManaged public var taskItem: NSSet?
    
    public var wListColor: String {
        listColor ?? "purple"
    }
    
    public var wListTitle: String {
        listTitle ?? "NoTitle"
    }
    
    public var wListIcon: String {
        listIcon ?? "leaf"
    }
    
    public var wTaskItem: [TaskItemEntity] {
        let set = taskItem as? Set<TaskItemEntity> ?? []
        
        return set.sorted {
            $0.wTitle < $1.wTitle
        }
    }

}

// MARK: Generated accessors for taskItem
extension ListItemEntity {

    @objc(addTaskItemObject:)
    @NSManaged public func addToTaskItem(_ value: TaskItemEntity)

    @objc(removeTaskItemObject:)
    @NSManaged public func removeFromTaskItem(_ value: TaskItemEntity)

    @objc(addTaskItem:)
    @NSManaged public func addToTaskItem(_ values: NSSet)

    @objc(removeTaskItem:)
    @NSManaged public func removeFromTaskItem(_ values: NSSet)

}

extension ListItemEntity : Identifiable {

}
