//
//  ContentView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var taskVM: TaskViewModel
    @EnvironmentObject var notifyManager: NotificationManager
    
    @State var searched = ""
    
    @State private var showAddView: Bool = false
    @State private var showEditView: Bool = false
    @State private var showQuickAddView: Bool = false
    
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
                    ListViewAlternativ()
                        .environmentObject(taskVM)
                        .environmentObject(userVM)
                        .environmentObject(notifyManager)
                } else {
                    ListViewClassic()
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
                                    showQuickAddView = true
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
            }
            .accentColor(userVM.colorTheme(colorPick: userVM.savedUserData.first!.wThemeColor))
//            .toolbar {
//                ToolbarItem(placement: .keyboard) {
//                    VStack {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                focusStatus = nil
//                            }) {
//                                Image(systemName: "keyboard.chevron.compact.down")
//                            }
//                            .padding(.horizontal, 10)
//                        }
////                        AddTaskView(taskVM: taskVM)
////                            .environmentObject(notifyManager)
//                    }
//
//                }
//            }
            .navigationBarTitle("SwiftlyTasks", displayMode: .inline)
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
                .foregroundColor(userVM.colorTheme(colorPick: userVM.savedUserData.first!.wThemeColor))
            )
            .sheet(isPresented: $showAddView) {
                AddTaskView(taskVM: taskVM)
                    .environmentObject(userVM)
            }
            .sheet(isPresented: $showQuickAddView) {
                QuickAddTaskView()
                    .environmentObject(taskVM)
                    .environmentObject(userVM)
                    .environmentObject(notifyManager)
            }
        }
        .onAppear {
            // update user name
            currentUserName = userVM.savedUserData.first?.wUserName ?? "NoName"
            switchUIDesigen = userVM.savedUserData.first?.switchUITheme ?? false
        }
    }
    
    private func changeProfileImg() {
        print("Chagne profile image")
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .preferredColorScheme(.dark)
    }
}
