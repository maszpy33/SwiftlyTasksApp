//
//  ContentView.swift
//  SwiftlyTasksApp
//
//  Created by Andreas Zwikirsch on 17.02.22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
//    @Environment(\.managedObjectContext) private var moc
    @StateObject var listVM = ListViewModel()
    @StateObject var taskVM = TaskViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var notifyManager = NotificationManager()
    
    var body: some View {
        TabView {
            if listVM.savedLists.isEmpty {
                NoTaskView()
                    .environmentObject(listVM)
                    .environmentObject(userVM)
                    .environmentObject(taskVM)
                    .environmentObject(notifyManager)
                    .transition(AnyTransition.opacity.animation(.easeIn))
                    .tabItem {
                        Image(systemName: "checkmark.square")
                        Text("Task List")
                    }
            } else {
//                ListView()
                ListsHomeView()
                    .environmentObject(listVM)
                    .environmentObject(userVM)
                    .environmentObject(taskVM)
                    .environmentObject(notifyManager)
                    .tabItem {
//                        Image(systemName: "checkmark.square")
//                        Text("Task List")
                        Image(systemName: "checklist")
                        Text("Lists")
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
                .environmentObject(listVM)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(userVM.colorTheme(colorPick: userVM.savedUserData.first?.wThemeColor ?? "noColorFoud"))
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
