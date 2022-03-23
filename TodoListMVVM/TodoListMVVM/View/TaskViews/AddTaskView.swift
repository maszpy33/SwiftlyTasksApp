//
//  AddTaskView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI
import Combine


struct AddTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var taskVM: TaskViewModel
//    var task: TaskItemEntity
    
    // Model Variables
    @State var taskTitleTextField: String = ""
    @State var taskDetailsTextField: String = ""
    @State var taskCategory: String = "private"
    @State var taskCategorySymbole: String = "🤷🏻‍♂️"
    @State var taskDueDate: Date = Date()
    @State var taskPriority: String = "normal"
    @State var taskStatus: Bool = false
    @State var taskUIDeleted: Bool = false
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 15)
                
                HStack {
                    // STATUS TOGGLE
                    ZStack {
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(taskStatus ? .gray : taskVM.styleForPriority(taskPriority: taskPriority))
                            .opacity(taskStatus ? 0.8 : 1)
                        
                        Image(systemName: "checkmark.square.fill")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.gray)
                            .font(.system(size: 22, weight: .bold, design: .default))
                            .opacity(taskStatus ? 1 : 0)
                    }
                    .onTapGesture {
                        withAnimation(.linear) {
                            taskStatus.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    // DUEDATE
                    DatePicker("no label", selection: $taskDueDate, in: Date()..., displayedComponents: .date)
                        .foregroundColor(.accentColor)
                        .frame(height: 55)
                        .cornerRadius(10)
                        .pickerStyle(.menu)
                        .labelsHidden()
                    
                    Spacer()
                    
                    // PRIORITY
                    Menu {
                        Picker("", selection: $taskPriority) {
                            ForEach(taskVM.taskPriorityOptions, id: \.self) {
                                Text($0.capitalized)
                            }
                        }
                        .font(.headline)
                    } label: {
                        Image(systemName: "flag.fill")
                            .font(.title2)
                            .foregroundColor(taskVM.styleForPriority(taskPriority: taskPriority))
                    }
                }
                .padding(.horizontal, 15)
                
                ScrollView {
                    VStack {
                        HStack {
                            // Emoji input
                            TextField("🤷🏻‍♂️", text: $taskCategorySymbole)
                                .font(.title)
                                .frame(width: 55, height: 55)
                                .cornerRadius(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.accentColor, lineWidth: 4))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                                .onReceive(Just(self.taskCategorySymbole)) { inputValue in
                                    if inputValue.emojis.count > 1 {
                                        self.taskCategorySymbole.removeFirst()
                                    } else if inputValue != "" {
                                        if !inputValue.isSingleEmoji {
                                            self.taskCategorySymbole = "🤷🏻‍♂️"
                                        }
                                    } else {
                                        self.taskCategorySymbole = inputValue
                                    }
                                }
                            
                            // TITLE
                            TextField("Add new task...", text: $taskTitleTextField)
                                .font(.headline)
                                .padding(10)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        
                        //                    // DETAILS
                        //                    TextField("Add new task description...", text: $taskDetailsTextField)
                        //                        .font(.headline)
                        //                        .padding(.leading)
                        //                        .frame(height: 55)
                        //                        .background(Color.gray)
                        //                        .cornerRadius(10)
                        
                        // CATEGORY
                        //                                Picker(selection: $taskCategory,
                        //                                       label:
                        //                                        Text("\(taskCategory)")
                        //                                        .font(.system(size: 18, weight: .bold))
                        //                                        .foregroundColor(.white)
                        //                                ) {
                        //                                    ForEach(taskVM.taskCategoryOptions, id: \.self) {
                        //                                        Text($0.capitalized)
                        //                                    }
                        //                                }
                        //                                .foregroundColor(.white)
                        //                                .frame(height: 55)
                        //                                .frame(maxWidth: .infinity)
                        //                                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                        //                                .cornerRadius(10)
                        //                                //                        .padding(5)
                        //                                .pickerStyle(.menu)
                        
                        // SAVE BUTTON
                        Button(action: {
                            // check if input is valid
                            guard !taskTitleTextField.isEmpty else {
                                        self.errorTitle = "input error"
                                        self.errorMessage = "Pleace enter a title to save the task"
                                        self.showAlert = true
                                        return
                                    }

                            // ADD NEW TASK
                            taskVM.saveTaskEntitys(title: taskTitleTextField, details: taskDetailsTextField, category: taskCategory, categorySymbol: taskCategorySymbole, priority: taskPriority, dueDate: taskDueDate, status: taskStatus, uiDeleted: taskUIDeleted)

                            taskTitleTextField = ""
                            
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }, label: {
                            Text("Save")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor.opacity(0.2))
                                .cornerRadius(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.accentColor, lineWidth: 4))
                                .cornerRadius(10)
                        })
                            .padding(15)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func checkForEmoji() -> Bool {
        guard taskCategorySymbole.isSingleEmoji else {
            return false
        }
        return true
    }
}

struct AddTaskView_Previews: PreviewProvider {
    
    @State static var defaultIsEditView = false
    
    static var previews: some View {
        AddTaskView(taskVM: TaskViewModel())
            .preferredColorScheme(.dark)
    }
}



