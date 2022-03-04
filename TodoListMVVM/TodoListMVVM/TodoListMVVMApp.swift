//
//  TodoListMVVMApp.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI

@main
struct TodoListMVVMApp: App {
    
    let persistentContainer = DataManager.shared.persistentContainer
//    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
//        .onChange(of: scenePhase) { _ in
//            persistentContainer.viewContext.save()
//        }
    }
}
