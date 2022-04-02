//
//  TaskView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI

struct TaskView: View {
    
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var taskVM: TaskViewModel
    var task: TaskItemEntity
    
    @State private var daysHoursLeft: Int = 0
    @State private var daysHoursString: String = ""
    @State private var overdueLimit: Int16 = 100
    @State private var onlyOneDayLeft = false
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                HStack {
                    // TASK EMOJI
                    Text("\(task.wTaskEmoji)")
                        .font(.title)
                    
                    // TASK TITLE
                    VStack(alignment: .leading) {
                        Text("Title:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(task.title ?? "no title")
                            .font(.system(size: 15, weight: .bold))
                            .italic()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        // TASK TIME LEFT
                        Text("\(daysHoursString) Left:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("\(daysHoursLeft)")
                                .font(.system(size: 18, weight: .bold))
                                .italic()
                                .foregroundColor(self.onlyOneDayLeft ? .red : .primary)
                            Text(" \(daysHoursString)")
                        }
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        // TASK DUE DATE
                        Text("Due Date:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Text(task.dueDate ?? Date(), style: .date)
                            Text(task.dueDate ?? Date(), style: .time)
                                .opacity(task.uiDeleted ? 1 : 0)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            // HAS DETAILS ICON
                            if task.hasDetails {
                                Image(systemName: "text.alignleft")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.gray)
                            }
                            
                            // TASK STATUS
                            Image(systemName: task.status ? "checkmark.square" : "xmark.square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundColor(task.status ? .green : .gray)
                        }
                    }
                    
                }
            }
            .padding(10)
            .background(taskVM.styleForPriority(taskPriority: task.priority ?? "normal").opacity(0.2))
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(taskVM.styleForPriority(taskPriority: task.wPriority), lineWidth: 0.7))
            .opacity(task.status ? 0.7 : 1)
        }
        .onAppear {
            if task.uiDeleted {
                (self.daysHoursLeft, self.daysHoursString) = taskVM.daysHoursLeft(dueDate: task.dueDate ?? Date())
            } else {
                (self.daysHoursLeft, self.daysHoursString) = taskVM.daysLeft(dueDate: task.dueDate ?? Date())
            }
            
            self.overdueLimit = userVM.savedUserData.first?.taskOverdueLimit ?? 100
            
            self.checkIfOnlyOneDayLeft()

            if self.daysHoursLeft <= -overdueLimit {
                deleteOverdueTasks(overdueLimit: overdueLimit)
            }
        }
    }
    
    private func checkIfOnlyOneDayLeft() {
        guard task.status == false else {
            return
        }
        
        guard task.uiDeleted == false else {
            return
        }
        
        guard daysHoursLeft + Int(overdueLimit) == 1 else {
            return
        }
        
        onlyOneDayLeft = true
    }
    
    private func deleteOverdueTasks(overdueLimit: Int16) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(overdueLimit)) {
            withAnimation(.linear) {
                taskVM.deleteTaskEntity(with: task.id)
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(userVM: UserViewModel(), taskVM: TaskViewModel(), task: TaskItemEntity())
        //        TaskView(task: TaskItem(title: "Title"))
    }
}
