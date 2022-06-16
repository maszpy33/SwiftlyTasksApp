//
//  ListsHomeView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 20.05.22.
//

import SwiftUI

struct ListsHomeView: View {
    
    @EnvironmentObject var listVM: ListViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var taskVM: TaskViewModel
    @EnvironmentObject var notifyManager: NotificationManager
    
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
    
    // LIST VARIABLES
    @State var showAddListView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
//                if switchUIDesigen {
//                    ListViewAlternativ()
//                        .environmentObject(listVM)
//                        .environmentObject(taskVM)
//                        .environmentObject(userVM)
//                        .environmentObject(notifyManager)
//                } else {
//                    ListViewClassic()
//                        .environmentObject(listVM)
//                        .environmentObject(taskVM)
//                        .environmentObject(userVM)
//                        .environmentObject(notifyManager)
//                }
                
                List {
                    HStack {
                        Text("Lists:")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.accentColor)
                            .opacity(0.7)
                        
                        Spacer()
                    }
                    
                    // LIST OF LISTS
                    ForEach(listVM.savedLists, id: \.self) { taskList in
                        NavigationLink(destination:
                                        ListView(taskList: taskList)
                                            .environmentObject(listVM)
                                            .environmentObject(taskVM)
                                            .environmentObject(userVM)
                                            .environmentObject(notifyManager),
                                       label: {
                            HStack {
                                Image(systemName: taskList.wListIcon)
                                Text(taskList.wListTitle)
                            }
                        })
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withAnimation(.linear(duration: 0.4)) {
                                    listVM.deleteListEntity(with: taskList.id)
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
            }
            .accentColor(userVM.colorTheme(colorPick: userVM.savedUserData.first?.wThemeColor ?? "purple"))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    // NAVIGATION BAR ITEMS
                                HStack {
//                Button(action: {
//                    changeProfileImg()
//                }) {
//                    HStack {
//                        ProfileView(userVM: userVM)
//                    }
//                }
                Button(action: {
                    withAnimation(.linear) {
                        showAddListView.toggle()
                    }
                }, label: {
                    HStack {
                        Image(systemName: "plus.square")
                        Text("Add List")
                    }
                })
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
                AddTaskView(listOfTask: listVM.savedLists.first!)
                    .environmentObject(taskVM)
                    .environmentObject(userVM)
                    .environmentObject(notifyManager)
            }
            .sheet(isPresented: $showAddListView) {
                AddListView()
                    .environmentObject(listVM)
                    .environmentObject(userVM)
//                    .environmentObject(notifyManager)
            }
            // showQuickAddView sheet is currently disabeld in favour of HalfASheet
//            .sheet(isPresented: $showQuickAddView) {
//                QuickAddTaskView()
//                    .environmentObject(taskVM)
//                    .environmentObject(userVM)
//                    .environmentObject(notifyManager)
//            }
        }
        .onAppear {
            // update user name
            currentUserName = userVM.savedUserData.first?.wUserName ?? "NoName"
            switchUIDesigen = userVM.savedUserData.first?.switchUITheme ?? false
        }
    }
//    }
}

struct ListsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ListsHomeView()
    }
}
