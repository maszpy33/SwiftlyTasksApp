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
    @NSManaged public var timerDuration: Int32
    @NSManaged public var timerBreakDuration: Int32
    @NSManaged public var timerRounds: Int32
    @NSManaged public var switchUITheme: Bool
    
    public var wUserName: String {
        userName ?? "UserName"
    }
    public var wThemeColor: String {
        themeColor ?? "purple"
    }
}

extension UserEntity : Identifiable {

}
