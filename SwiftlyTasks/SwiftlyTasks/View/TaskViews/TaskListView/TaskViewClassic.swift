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
            userVM.secondaryAccentColor
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
                        HStack {
                            // TASK STATUS
                            Image(systemName: task.status ? "checkmark.square" : "square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundColor(task.status ? .green : .gray)
                            
                            // HAS REMINDER ACTIVATED
                            if task.hasAlert {
                                Image(systemName: "bell.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.gray)
                            }
                            
                            // HAS DETAILS ICON
                            if task.hasDetails {
                                Image(systemName: "text.alignleft")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        // TASK DUE DATE
                        Text("Due Date:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Text(task.dueDate ?? Date(), style: .date)
                            Text(task.dueDate ?? Date(), style: .time)
                                .opacity(task.uiDeleted ? 1 : 0)
                            Text("uhr")
                                .opacity(task.uiDeleted ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
//            .modifier(TransparentButton(themeColor: taskVM.styleForPriority(taskPriority: task.wPriority), taskIsDone: task.status))
            .background(taskVM.styleForPriority(taskPriority: task.wPriority).opacity(0.2))
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(taskVM.styleForPriority(taskPriority: task.wPriority), lineWidth: 0.7))
            .opacity(task.status ? 0.7 : 1)
        }
        .onAppear {
            (self.daysHoursLeft, self.daysHoursString) = taskVM.daysHoursLeft(dueDate: task.dueDate ?? Date(), hasTime: task.uiDeleted)
            
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
