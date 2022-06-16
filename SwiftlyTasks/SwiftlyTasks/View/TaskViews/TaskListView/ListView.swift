//
//  ContentView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI
import HalfASheet

struct ListView: View {
    
    @EnvironmentObject var listVM: ListViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var taskVM: TaskViewModel
    @EnvironmentObject var notifyManager: NotificationManager
    
    @State var taskList: ListItemEntity
    
    @State var searched = ""
    
    @State private var showAddView: Bool = false
    @State private var showEditView: Bool = false
    @State private var showQuickAddView: Bool = false // currently disabled
    @State private var showQuickAddHalfASheet: Bool = false
    
    @State private var currentUserName: String = "UserName"
    
    @FocusState private var focusStatus: Field?
    
    @State private var dragAmount = CGSize.zero
    @State private var enabled = false
    @State private var scaleAmount: Double = 1.0
    
    @State private var switchUIDesigen: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if switchUIDesigen {
                    ListViewAlternativ(taskList: taskList)
                        .environmentObject(listVM)
                        .environmentObject(taskVM)
                        .environmentObject(userVM)
                        .environmentObject(notifyManager)
                } else {
                    ListViewClassic(taskList: taskList)
                        .environmentObject(listVM)
                        .environmentObject(taskVM)
                        .environmentObject(userVM)
                        .environmentObject(notifyManager)
                }
                
                // ADD TASK BUTTON
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddTaskButtonView()
                            .environmentObject(userVM)
                            .scaleEffect(self.scaleAmount)
                            .offset(self.dragAmount)
                            .padding()
                            .onTapGesture {
                                // ANIMATE BUTTON EFFECT WHILE MAINTING DRAG GESTURE
                                DispatchQueue.main.async {
                                    withAnimation(.default) {
                                        scaleAmount = 0.7
                                    }
                                    withAnimation(.default.delay(0.2)) {
                                        scaleAmount = 1.0
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                                    showQuickAddView = true
                                    showQuickAddHalfASheet = true
                                }
                            }
                            .gesture(DragGesture()
                                .onChanged { self.dragAmount = $0.translation }
                                .onEnded { _ in
                                    withAnimation(.easeOut.delay(0.5)) {
                                        self.dragAmount = .zero
                                        self.enabled.toggle()
                                    }
                                })
                    }
                }
                
                // HALF A SHEET
                HalfASheet(isPresented: $showQuickAddHalfASheet, title: "Quick Add Task View") {
                    QuickAddTaskView(listOfTask: taskList)
                        .environmentObject(taskVM)
                        .environmentObject(userVM)
                        .environmentObject(notifyManager)
                }
                .height(.proportional(0.75))
                .backgroundColor(UIColor(taskVM.secondaryAccentColor))
                .closeButtonColor(UIColor(red: 0.8, green: 0.2, blue: 0.1, alpha: 0.7))
                .contentInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
            }
            .accentColor(userVM.colorTheme(colorPick: userVM.savedUserData.first?.wThemeColor ?? "purple"))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    // NAVIGATION BAR ITEMS
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
                .foregroundColor(userVM.colorTheme(colorPick: userVM.savedUserData.first?.wThemeColor ?? "purple"))
            )
            .sheet(isPresented: $showAddView) {
                AddTaskView(listOfTask: taskList)
                    .environmentObject(taskVM)
                    .environmentObject(userVM)
                    .environmentObject(notifyManager)
            }
            // showQuickAddView sheet is currently disabeld in favour of HalfASheet
            .sheet(isPresented: $showQuickAddView) {
                QuickAddTaskView(listOfTask: taskList)
                    .environmentObject(taskVM)
                    .environmentObject(userVM)
                    .environmentObject(notifyManager)
            }
        }
        .onAppear {
            // update user name
            currentUserName = userVM.savedUserData.first?.wUserName ?? "NoName"
            switchUIDesigen = userVM.savedUserData.first?.switchUITheme ?? false
            
            print("\n******************")
            print("****\(taskList.wListTitle)****")
            print("******************\n")
        }
    }
    
    private func changeProfileImg() {
        print("Chagne profile image")
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//            .preferredColorScheme(.dark)
//    }
//}
