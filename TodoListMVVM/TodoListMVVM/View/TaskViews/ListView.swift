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
    @State private var showQuickAddView: Bool = false
    
    @State private var currentUserName: String = "UserName"
    
    @FocusState private var focusStatus: Field?
    //    @State private var hiddenText: String = ""
    //    @State var focusFieldChange = false
    
    @State private var dragAmount = CGSize.zero
    @State private var enabled = false
    @State private var scaleAmount: Double = 1.0
    
    var body: some View {
        NavigationView {
            ZStack {
                
                //                Color.green
                //                userVM.secondaryAccentColor
                //                    .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(taskVM.searchableTasks) { taskEntity in
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
                
                // ADD TASK BUTTON
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddTaskButtonView()
                            .environmentObject(taskVM)
                            .scaleEffect(self.scaleAmount)
                            .offset(self.dragAmount)
                            .padding()
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    withAnimation(.default) {
                                        scaleAmount = 0.7
                                    }
                                    withAnimation(.default.delay(0.2)) {
                                        scaleAmount = 1.0
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    showQuickAddView = true
                                }
                            }
                            .gesture(DragGesture()
                                .onChanged { self.dragAmount = $0.translation }
                                .onEnded { _ in
                                    withAnimation(.easeOut.delay(0.2)) {
                                        self.dragAmount = .zero
                                        self.enabled.toggle()
                                    }
                                })
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                focusStatus = nil
                            }) {
                                Image(systemName: "keyboard.chevron.compact.down")
                            }
                            .padding(.horizontal, 10)
                        }
                        AddTaskView(taskVM: taskVM)
                    }
                    
                }
            }
            .navigationTitle("SwiftlyTasks")
            .navigationBarItems(leading:
                                    HStack {
                Button(action: {
                    changeProfileImg()
                }) {
                    HStack {
                        ProfileView(userVM: userVM)
                    }
                }
                Text("\(currentUserName)")
                    .font(.headline)
            },
                                trailing:
                                    HStack {
                Text("\(taskVM.savedTasks.filter({ $0.status == false }).count)")
                    .font(.title2)
                    .bold()
                
                Button(action: {
                    showAddView.toggle()
                }) {
                    Image(systemName: "plus.square")
                }
            }
                .foregroundColor(.accentColor)
            )
            .sheet(isPresented: $showAddView) {
                AddTaskView(taskVM: taskVM)
            }
            .sheet(isPresented: $showQuickAddView) {
                QuickAddTaskView()
                    .environmentObject(taskVM)
            }
        }
        .onAppear {
            // update user name
            currentUserName = userVM.savedUserData.first?.wUserName ?? "NoName"
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
