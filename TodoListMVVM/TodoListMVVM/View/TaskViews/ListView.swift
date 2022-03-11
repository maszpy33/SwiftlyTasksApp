//
//  ContentView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var taskVM: TaskViewModel
    @ObservedObject var userVM: UserViewModel
    
    @State var searched = ""
    
    @State private var showAddView: Bool = false
    @State private var showEditView: Bool = false
    
    @State private var currentUserName: String = "UserName"
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(taskVM.savedTasks) { taskEntity in
                    NavigationLink(destination: EditView(taskVM: taskVM, task: taskEntity), label: {
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
                        .tint(taskEntity.status ? .gray : .green)
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
            //                    }
            
            //                TaskSearchView(taskVM: taskVM)
            //                Text("Enter Search Bar here")
            //                SortPickerView(taskVM: taskVM)
            //                TaskListView(taskVM: taskVM)
            .navigationTitle("SwiftlyTasks")
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = UIColor(.primary)
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
            .navigationBarItems(leading:
                                    Button(action: {
                changeProfileImg()
            }) {
                HStack {
                    ProfileView(userVM: userVM)
                    Text("\(currentUserName)")
                        .font(.headline)
                }
            },
                                trailing:
                                    HStack {
                Text("\(taskVM.savedTasks.filter({ $0.status == false }).count)")
                    .font(.title2)
                    .bold()
                
                Button(action: {
                    self.showAddView.toggle()
                }) {
                    Image(systemName: "plus.square")
                }
            }
                                    .foregroundColor(.accentColor)
            )
            .sheet(isPresented: $showAddView) {
                AddTaskView(taskVM: taskVM)
            }
        }
        .onAppear {
            // update user name
            currentUserName = userVM.savedUserData.first!.wUserName
        }
        .introspectNavigationController { nav in
            nav.navigationBar.barTintColor = UIColor(Color(red: 0.2, green: 0.2, blue: 0.2))
        }
    }
    
    private func changeProfileImg() {
        print("Chagne profile image")
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(taskVM: TaskViewModel(), userVM: UserViewModel())
            .preferredColorScheme(.dark)
    }
}
