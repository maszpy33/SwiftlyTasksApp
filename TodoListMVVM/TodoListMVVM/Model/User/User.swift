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
//    var userProfilImage: BinaryInteger
    let taskOverdueLimit: Int16
    let themeColor: String
    let profileImage: UIImage
    // just cast the profileImage variable name when it's saved to core data.
    // here it should be fine to cast it as UIImage
}
