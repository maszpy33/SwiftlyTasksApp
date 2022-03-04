//
//  EditView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 16.02.22.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var taskVM: TaskViewModel
    var task: TaskItemEntity
    
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
            ScrollView {
                Section(header: Text("Edit Task Details:")) {
                    // one view for edit and add task, so UI changes only have to be done in one view
                    ChangeView(taskVM: taskVM, taskTitleTextField: $taskTitleTextField, taskDetailsTextField: $taskDetailsTextField, taskCategory: $taskCategory, taskCategroySymbol: $taskCategorySymbole, taskDueDate: $taskDueDate, taskPriority: $taskPriority, taskStatus: $taskStatus)
                }
                
                // STATUS TOGGLE
                Toggle("Task Status Toggle:", isOn: $taskStatus)
                    .padding()
                    .toggleStyle(CheckboxStyle())
                
                // SAVE BUTTON
                Button(action: {
                    // check if input is valid
                    guard !taskTitleTextField.isEmpty else {
                                self.errorTitle = "input error"
                                self.errorMessage = "pleace enter a title to save the task"
                                self.showAlert = true
                                return
                            }
                    
                    // SAVE CHANGES
                    taskVM.updateTaskEntity(taskEntity: task, newTitle: taskTitleTextField, newDetails: taskDetailsTextField, newCategory: taskCategory, newCategorySymbol: taskCategorySymbole, newPriority: taskPriority, newDueDate: taskDueDate, newStatus: taskStatus, newUIDelete: taskUIDeleted)
                    
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
                        .padding(10)
                })
                    .padding()
            }
//            .ignoresSafeArea()
            .navigationTitle("🃏 Edit Task")
            .onAppear {
                // assigen values of task to temporary variables
                taskTitleTextField = task.title ?? "no title"
                taskDetailsTextField = task.details ?? "no details"
                taskCategory = task.category ?? "private"
                taskDueDate = task.dueDate ?? Date()
                taskPriority = task.priority ?? "normal"
                taskStatus = task.status
                taskUIDeleted = task.uiDeleted
            }
        }
        .alert(isPresented: $showAlert) {
                        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct EditView_Previews: PreviewProvider {
    
    @State static var defaultIsEditView = false
    
    static var previews: some View {
        EditView(taskVM: TaskViewModel(), task: TaskItemEntity())
    }
}
