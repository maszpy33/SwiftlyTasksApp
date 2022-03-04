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
    
    @State private var daysLeft: Int = 0
    @State private var overdueLimit: Int16 = 100
    @State private var onlyOneDayLeft = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: task.categorySymbol ?? "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.primary)
                
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
                    Text("Days Left:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("\(daysLeft)")
                            .font(.system(size: 18, weight: .bold))
                            .italic()
                            .foregroundColor(self.onlyOneDayLeft ? .red : .primary)
                        Text(" Days")
                    }
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Due Date:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(task.dueDate ?? Date(), style: .date)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Image(systemName: task.status ? "checkmark.square" : "xmark.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(task.status ? .green : .gray)
                }
                
            }
        }
        .padding(10)
        .background(taskVM.styleForPriority(taskPriority: task.priority ?? "normal").opacity(0.2))
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(taskVM.styleForPriority(taskPriority: task.priority ?? "normal"), lineWidth: 0.7))
        .opacity(task.status ? 0.7 : 1)
        .onAppear {
            self.daysLeft = taskVM.daysLeft(dueDate: task.dueDate ?? Date())
            self.overdueLimit = userVM.savedUserData.first?.taskOverdueLimit ?? 100
            
            self.checkIfOnlyOneDayLeft()
            
            // taskoverduelimit is implemented in TaskViewModel to have centrall acces
//            Int(userVM.savedUserData.first!.taskOverdueLimit)
            if self.daysLeft <= -overdueLimit {
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
        
        guard daysLeft + Int(overdueLimit) == 1 else {
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
