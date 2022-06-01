//
//  SwiftlyTasksApp.swift
//  SwiftlyTasksApp
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI

@main
struct SwiftlyTasksApp: App {
    
    let persistentContainer = DataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
