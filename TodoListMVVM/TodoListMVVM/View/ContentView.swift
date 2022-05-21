//
//  ContentView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 17.02.22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
//    @Environment(\.managedObjectContext) private var moc
    @StateObject var taskVM = TaskViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var notifyManager = NotificationManager()
    
    var body: some View {
        TabView {
            if taskVM.savedTasks.isEmpty {
                NoTaskView(taskVM: taskVM)
                    .transition(AnyTransition.opacity.animation(.easeIn))
                    .tabItem {
                        Image(systemName: "checkmark.square")
                        Text("Task List")
                        
                    }
            } else {
                ListView(taskVM: taskVM, userVM: userVM)
                    .environmentObject(notifyManager)
                    .tabItem {
                        Image(systemName: "checkmark.square")
                        Text("Task List")
                    }
            }
            
//            ListsHomeView()
//                .tabItem {
//                    Image(systemName: "doc.text.fill")
//                    Text("ListView")
//                }
            
            PomodoroView(userVM: userVM, taskVM: taskVM)
                .environmentObject(notifyManager)
                .tabItem {
                    Image(systemName: "timer.square")
                    Text("Pomodoro Timer")
                }
            
            SettingsView(userVM: userVM)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
                if let error = error {
                    print("ERROR \(error)")
                } else {
                    print("NOTIFICATION PERMISSION SUCCESS")
                }
            }
            UNUserNotificationCenter.current().delegate = notifyManager
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
