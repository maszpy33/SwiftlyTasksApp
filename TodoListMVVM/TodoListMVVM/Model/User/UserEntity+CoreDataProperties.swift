//
//  UserEntity+CoreDataProperties.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var themeColor: String?
    @NSManaged public var taskOverdueLimit: Int16
    @NSManaged public var userName: String?
    @NSManaged public var timerDuration: Int16
    @NSManaged public var timerBreakDuration: Int16
    @NSManaged public var timerRounds: Int16

}

extension UserEntity : Identifiable {

}
