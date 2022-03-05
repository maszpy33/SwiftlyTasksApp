//
//  AddTaskView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var taskVM: TaskViewModel
//    var task: TaskItemEntity
    
    // Model Variables
    @State var taskTitleTextField: String = ""
    @State var taskDetailsTextField: String = ""
    @State var taskCategory: String = "private"
    @State var taskCategorySymbole: String = "number.square"
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
                ChangeView(taskVM: taskVM, taskTitleTextField: $taskTitleTextField, taskDetailsTextField: $taskDetailsTextField, taskCategory: $taskCategory, taskCategroySymbol: $taskCategorySymbole, taskDueDate: $taskDueDate, taskPriority: $taskPriority, taskStatus: $taskStatus)
                
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
}

struct AddTaskView_Previews: PreviewProvider {
    
    @State static var defaultIsEditView = false
    
    static var previews: some View {
        AddTaskView(taskVM: TaskViewModel())
    }
}
