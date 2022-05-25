//
//  TaskPriorityPicker.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 25.05.22.
//

import SwiftUI

struct TaskPriorityPicker: View {
    @EnvironmentObject var taskVM: TaskViewModel
    @Binding var taskPriority: String
    
    var body: some View {
        // PRIORITY
        Menu {
            Picker("", selection: $taskPriority) {
                ForEach(taskVM.taskPriorityOptions, id: \.self) { prio in
                    Text(prio.capitalized)
                }
            }
            .font(.headline)
        } label: {
            Image(systemName: "flag.fill")
                .font(.title2)
                .foregroundColor(taskVM.styleForPriority(taskPriority: taskPriority))
        }
    }
}

//struct TaskPriorityPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskPriorityPicker(prio: "Low", prioSymbol: "!", taskForegroundColor: Color.blue)
//    }
//}
