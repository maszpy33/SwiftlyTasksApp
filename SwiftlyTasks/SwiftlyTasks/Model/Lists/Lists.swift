//
//  File.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 13.06.22.
//

import Foundation

struct ListItem: Identifiable, Equatable, Hashable {
    var id: String = UUID().uuidString
    var listTitle: String
    var listIcon: String
    var listColor: String
}
