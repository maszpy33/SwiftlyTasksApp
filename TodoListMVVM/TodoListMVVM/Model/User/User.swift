//
//  User.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import Foundation


struct User: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let userName: String
//    var userProfilImage: BinaryInteger
    let taskOverdueLimit: Int16
    let themeColor: String
}
