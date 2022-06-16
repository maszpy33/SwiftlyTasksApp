//
//  ListViewModel.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 13.06.22.
//

import Foundation
import SwiftUI

class ListViewModel: DataClassViewModel {
    let listIconOptions = ["swift", "checklist", "list.bullet", "list.star", "pencil", "clock", "alarm", "heart.circle", "brain.head.profile", "bed.double.circle", "star","keyboard", "laptopcomputer", "iphone", "ipad", "applewatch", "airpodspro", "gamecontroller.fill", "airplane", "car", "bus", "tram", "figure.walk", "person", "person.3", "globe.europe.africa.fill", "flame", "drop", "bolt", "pawprint", "leaf", "message", "quote.bubble", "cart", "giftcard.fill", "creditcard", "eurosign.circle", "x.squareroot", "number.square"]
    
    let colorPlate = ["purple", "blue", "green"]
    
    override init() {
        super.init()
        // initUser when app is first started
        if savedLists.isEmpty {
            saveNewListEntity(listTitle: "Reminder", listIcon: "checklist", listColor: "purple")
        }
    }
    
    // ***********************************
    // ***** LISTVIEWMODEL FUNCTIONS *****
    // ***********************************
    
    func saveListData() {
        do {
            try container.viewContext.save()
            fetchListsData()
        } catch {
            print("Error saving lists. \(error)")
        }
    }
    
    func saveNewListEntity(listTitle: String, listIcon: String, listColor: String) {
        let newList = ListItemEntity(context: container.viewContext)
        newList.listTitle = listTitle
        newList.listIcon = listIcon
        newList.listColor = listColor

        saveListData()
    }
    
    func deleteListEntity(with listID: ObjectIdentifier) {
        guard savedLists.count > 1 else {
            return
        }
        
        guard let listEntity = savedLists.first(where: { $0.id == listID }) else { return }
        
        container.viewContext.delete(listEntity)
        saveListData()
    }
    
//    func addNewTaskToList(newTask: TaskItemEntity, listID: ObjectIdentifier) {
//        let selectedList = savedLists.first(where: { $0.id == listID }) else { return }
//        selectedList.wTaskItem.append(newTask)
//    }
    
    func listColor(colorPick: String) -> Color {
        switch colorPick {
        case "purple":
            return Color.purple
        case "blue":
            return Color.blue
        case "green":
            return Color.green
        default:
            return Color.red
        }
    }
}
