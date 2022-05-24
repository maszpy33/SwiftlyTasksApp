//
//  ListViewClassic.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 24.05.22.
//

import SwiftUI

struct ListViewClassic: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var notifyManager: NotificationManager
    
    var body: some View {
        List {
            ForEach(taskVM.searchableTasks) { taskEntity in
                NavigationLink(destination: EditView(taskVM: taskVM, task: taskEntity).environmentObject(notifyManager), label: {
                    TaskView(userVM: userVM, taskVM: taskVM, task: taskEntity)
                })
                .padding(5)
                .listRowInsets(EdgeInsets())
                .swipeActions(edge: .leading) {
                    Button(action: {
                        withAnimation(.linear(duration: 0.4)) {
                            taskVM.updateTaskStatus(taskEntity: taskEntity)
                        }
                    }, label: {
                        VStack {
                            Image(systemName: taskEntity.status ? "xmark.square" : "checkmark.square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("\(taskEntity.status ? "uncheck" : "check")")
                        }
                    })
                }
                .tint(taskEntity.status ? .gray : Color(red: 0.3, green: 0.65, blue: 0.0))
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        withAnimation(.linear(duration: 0.4)) {
                            taskVM.deleteTaskEntity(with: taskEntity.id)
                        }

                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                }
                .tint(.red)
            }
        }
        .listStyle(PlainListStyle())
        .searchable(text: $taskVM.searchText)
    }
}

struct ListViewClassic_Previews: PreviewProvider {
    static var previews: some View {
        ListViewClassic()
    }
}
