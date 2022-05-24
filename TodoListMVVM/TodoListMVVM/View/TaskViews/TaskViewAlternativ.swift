//
//  TaskViewAlternativ.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 23.05.22.
//

import SwiftUI

struct TaskViewAlternativ: View {
    
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var taskVM: TaskViewModel
    var task: TaskItemEntity
    
    @State private var daysHoursLeft: Int = 0
    @State private var daysHoursString: String = ""
    @State private var overdueLimit: Int16 = 100
    @State private var onlyOneDayLeft = false
    
    var body: some View {
        ZStack {
//            userVM.secondaryAccentColor
//                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                HStack {
                    // TASK EMOJI
                    Text("\(task.wTaskEmoji)")
                        .font(.system(size: 30))
                        .shadow(color: .black, radius: 10)

                    
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

                }
                
                HStack {
                    // TASK PRIORITY
                    Image(systemName: "flag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundColor(taskVM.styleForPriority(taskPriority: task.wPriority))
                    
                    // TASK STATUS
                    Image(systemName: task.status ? "checkmark.square" : "xmark.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundColor(task.status ? .green : .gray)

                    // HAS DETAILS ICON
                    if task.hasDetails {
                        Image(systemName: "text.alignleft")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.gray)
                    }
                    
                    // HAS REMINDER ACTIVATED
                    if task.hasAlert {
                        Image(systemName: "bell.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .trailing) {
                        // TASK DUE DATE
                        HStack {
                            if task.uiDeleted {
                                Text(task.dueDate ?? Date(), style: .time)
                            }
                            Text("\(taskVM.getShortDate(dueDate: task.wDueDate))")
                        }
                        .font(.caption)
                    }

                    Spacer()
                    
                    // DAYS LEFT
                    Text(" \(daysHoursString)")
                        .font(.caption2)
                    Text("\(daysHoursLeft)")
                        .font(.system(size: 25, weight: .bold))
                        .italic()
                        .foregroundColor(self.onlyOneDayLeft ? .red : .primary)
                }
                .font(.caption)
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            .padding(.bottom, 10)
//            .modifier(TransparentButton(themeColor: taskVM.styleForPriority(taskPriority: task.wPriority), taskIsDone: task.status))
//            .background(taskVM.styleForPriority(taskPriority: task.wPriority).opacity(0.2))
//            .cornerRadius(10)
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

struct TaskViewAlternativ_Previews: PreviewProvider {
    static var previews: some View {
        TaskViewAlternativ(userVM: UserViewModel(), taskVM: TaskViewModel(), task: TaskItemEntity())
    }
}
