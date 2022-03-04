//
//  ContentView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 17.02.22.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.managedObjectContext) private var moc
    @StateObject var taskVM = TaskViewModel()
    @StateObject var userVM = UserViewModel()
    
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
                        .tabItem {
                            Image(systemName: "checkmark.square")
                            Text("Task List")
                        }
                }
                
                PomodoroView(userVM: userVM, taskVM: taskVM)
                    .tabItem {
                        Image(systemName: "timer.square")
//                        Text("🍅")
//                            .font(.title2)
                        Text("Pomodoro Timer")
                    }
                
                SettingsView(userVM: userVM)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
