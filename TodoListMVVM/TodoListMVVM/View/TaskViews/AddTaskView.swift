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
            Form {
                // one view for edit and add task, so UI changes only have to be done in one view
//                ChangeView(taskVM: taskVM, taskTitleTextField: $taskTitleTextField, taskDetailsTextField: $taskDetailsTextField, taskCategory: $taskCategory, taskCategroySymbol: $taskCategorySymbole, taskDueDate: $taskDueDate, taskPriority: $taskPriority, taskStatus: $taskStatus)
                VStack {
                    Section {
                        // TITLE
                        TextField("Add new task...", text: $taskTitleTextField)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray)
                            .cornerRadius(10)
                        //                        .padding()
                        
                        // DETAILS
                        TextField("Add new task description...", text: $taskDetailsTextField)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color.gray)
                            .cornerRadius(10)
                        //                        .padding()
                        
//                        HStack {
//                            // CATEGORY
//                            Picker(selection: $taskCategory,
//                                   label:
//                                    Text("\(taskCategory)")
//                                    .font(.system(size: 18, weight: .bold))
//                                    .foregroundColor(.white)
//                            ) {
//                                ForEach(taskVM.taskCategoryOptions, id: \.self) {
//                                    Text($0.capitalized)
//                                }
//                            }
//                            .foregroundColor(.white)
//                            .frame(height: 55)
//                            .frame(maxWidth: .infinity)
//                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
//                            .cornerRadius(10)
//                            //                        .padding(5)
//                            .pickerStyle(.menu)
//
//
//                            // CATEGORY SYMBOL
////                            Picker(selection: $taskCategorySymbole,
////                                   label:
////                                    Text("\(taskCategory)")
////                                    .font(.system(size: 18, weight: .bold))
////                                    .foregroundColor(.white)
////                            ) {
////                                ForEach(taskVM.taskCategorySymboleOptions.reversed(), id: \.self) {
////                                    Image(systemName: $0)
////                                }
////                            }
////                            .foregroundColor(.white)
////                            .frame(height: 55)
////                            .frame(maxWidth: .infinity)
////                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
////                            .cornerRadius(10)
////                            //                        .padding(5)
////                            .pickerStyle(.menu)
//                        }
                        
                        // DUEDATE
                        HStack {
                            // DUEDATE
                            DatePicker("no label", selection: $taskDueDate, in: Date()..., displayedComponents: .date)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .frame(height: 70)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                            //                            .padding(5)
                                .pickerStyle(.menu)
                                .labelsHidden()
                            
                            // Emoji input
                            TextField("🤷🏻‍♂️", text: $taskCategorySymbole)
                                .frame(width: 70, height: 70)
                                .font(.title2)
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                                .onReceive(Just(self.taskCategorySymbole)) { inputValue in
                                    if inputValue.emojis.count > 1 {
                                        self.taskCategorySymbole.removeFirst()
//                                        var currentEmojis = inputValue.emojis
//                                        self.taskCategorySymbole =
                                    } else if inputValue != "" {
                                        if !inputValue.isSingleEmoji {
                                            self.taskCategorySymbole = "🤷🏻‍♂️"
                                        }
                                    } else {
                                        self.taskCategorySymbole = inputValue
                                    }
                                }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Section {
                        // PRIORITY
                        Picker("", selection: $taskPriority) {
                            ForEach(taskVM.taskPriorityOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(taskVM.styleForPriority(taskPriority: taskPriority), lineWidth: 4)
                        )
                        .cornerRadius(10)
                        //                    .padding(10)
                        .pickerStyle(.segmented)
                    }
                }
                //        .padding(.vertical, 15)
                .padding(10)
        //        .background(Color.accentColor.opacity(0.2))
        //        .cornerRadius(10)
        //        .background(
        //            RoundedRectangle(cornerRadius: 10, style: .continuous)
        //                .stroke(Color.accentColor, lineWidth: 0.7)
        //        )
                
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
                                .stroke(Color.accentColor, lineWidth: 2))
                        .cornerRadius(10)
                        .padding(10)
                })
                    .padding()
            }
//            .ignoresSafeArea()
            .navigationTitle("🃏 Add new task:")
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
    }
}
