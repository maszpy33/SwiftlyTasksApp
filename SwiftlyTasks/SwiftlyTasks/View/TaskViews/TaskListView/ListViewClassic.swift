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
    
    @State private var showDoneTasks: Bool = false
    
    var body: some View {
        List {
            Text("Upcomming Tasks:")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.accentColor)
                .opacity(0.7)
            
            // LIST OF UPCOMMING TASKS
            ForEach(taskVM.searchableTasks.filter {$0.status == false}, id: \.self) { taskEntity in
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
            
            HStack {
                if showDoneTasks {
                    Image(systemName: showDoneTasks ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(showDoneTasks ? Color.green : Color.gray)
                        .opacity(0.7)
                }
                Toggle(isOn: $showDoneTasks.animation(.linear)) {
                    Text("Show Done Tasks")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.accentColor)
                        .opacity(0.7)
                }
//                    .padding(.leading, 15)
                    .padding(.trailing, 65)
                    .tint(Color.accentColor)
            }
            .padding(.top, 15)
            
            //FIXME: add showDoneTasks to userEntity
            // SHOW LIST OF DONE TASKS ON TOGGLE
            if showDoneTasks {
                ForEach(taskVM.searchableTasks.filter {$0.status == true}, id: \.self) { taskEntity in
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
