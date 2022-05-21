//
//  QuickAddTaskView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 15.05.22.
//

import SwiftUI
import Combine

struct QuickAddTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var taskVM: TaskViewModel
    //    var task: TaskItemEntity
    @State private var addTime: Bool = false
    @State private var showDefaultDetailsText: Bool = true
    
    @FocusState private var addTaskIsFocus: Bool
    
    // MODEL VARIABLES
    @State var taskTitleTextField: String = ""
    @State var taskDetailsTextField: String = ""
    @State var taskCategory: String = "private"
    @State var taskEmoji: String = "🤷🏻‍♂️"
    @State var taskDueDate: Date = Date()
    @State var taskPriority: String = "normal"
    @State var taskStatus: Bool = false
    @State var taskHasDetails: Bool = false
    @State var taskUIDeleted: Bool = false
    
    // DISMISS KEYBOARD VARIABLE
    @FocusState private var focusedField: Field?
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    Spacer()
                    
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
                        // if add specific time to task
                        if taskUIDeleted {
                            DatePicker("no label", selection: $taskDueDate, in: Date()...)
                                .foregroundColor(.accentColor)
                                .frame(height: 55)
                                .cornerRadius(10)
                                .pickerStyle(.menu)
                                .labelsHidden()
                            // no specific time for task -> set to default
                        } else {
                            DatePicker("no label", selection: $taskDueDate, in: Date()..., displayedComponents: .date)
                                .foregroundColor(.accentColor)
                                .frame(height: 55)
                                .cornerRadius(10)
                                .pickerStyle(.menu)
                                .labelsHidden()
                        }
                        
                        
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
                    
                    VStack {
                        
                        // DATE TIME TOGGLE
                        HStack{
                            Label("Time", systemImage: "clock.fill")
                                .font(.title3)
                                .foregroundColor(taskUIDeleted ? .accentColor : .gray)
                                .opacity(taskUIDeleted ? 1.0 : 0.7)
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        taskUIDeleted.toggle()
                                    }
                                }
                            
                            Spacer()
                            
                            // SHOW DETAILS TOGGLE
                            Label("Details", systemImage: "note")
                                .font(.title3)
                                .foregroundColor(taskHasDetails ? .accentColor : .gray)
                                .opacity(taskHasDetails ? 1.0 : 0.7)
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        taskHasDetails.toggle()
                                    }
                                }
                                .onChange(of: taskHasDetails) { taskDetailsStatus in
                                    
                                    // delete task details, when detials toggle is false
                                    if !taskDetailsStatus {
                                        taskDetailsTextField = ""
                                        showDefaultDetailsText = true
                                    }
                                }
                            
                            Spacer()
                            
                            // SAVE BUTTON
                            Button(action: {
                                // check if input is valid
                                guard !taskTitleTextField.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                    self.errorTitle = "input error"
                                    self.errorMessage = "Pleace enter a title to save the task"
                                    self.showAlert = true
                                    return
                                }
                                
                                // ADD NEW TASK
                                taskVM.saveTaskEntitys(title: taskTitleTextField, details: taskDetailsTextField, category: taskCategory, taskEmoji: taskEmoji, priority: taskPriority, dueDate: taskDueDate, status: taskStatus, hasDetails: taskHasDetails, uiDeleted: taskUIDeleted)
                                
                                taskTitleTextField = ""
                                taskDetailsTextField = ""
                                
                                self.presentationMode.wrappedValue.dismiss()
                                
                            }, label: {
                                Image(systemName: "plus.square.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 25, weight: .bold))
                                //                                .font(.title2)
                            })
                            .padding(.vertical, 5)
                            .disabled(taskTitleTextField.isEmpty)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                            }
                        }
                        .padding(.horizontal, 20)
                        .foregroundColor(.accentColor)
                        
                        HStack {
                            // EMOJI INPUT
                            TextField("🤷🏻‍♂️", text: $taskEmoji)
                                .focused($focusedField, equals: .taskEmoji)
                                .font(.title)
                                .frame(width: 55, height: 55)
                                .cornerRadius(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.accentColor, lineWidth: 4))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                                .onReceive(Just(self.taskEmoji)) { inputValue in
                                    if inputValue.emojis.count > 1 {
                                        self.taskEmoji.removeFirst()
                                    } else if inputValue != "" {
                                        if !inputValue.isSingleEmoji {
                                            self.taskEmoji = "🤷🏻‍♂️"
                                        }
                                    } else {
                                        self.taskEmoji = inputValue
                                    }
                                }
                            
                            // TITLE
                            TextField("Add new task...", text: $taskTitleTextField)
                                .focused($focusedField, equals: .taskTitleTextField)
                                .onAppear {
                                    self.focusedField = .taskTitleTextField
                                }
                                .font(.headline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .cornerRadius(10)
                            
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        
                        
                        // DETAILS
                        if taskHasDetails {
                            ZStack {
                                VStack(alignment: .leading) {
                                    Text("Add Details:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.bottom, 3)
                                    
                                    TextEditor(text: $taskDetailsTextField)
                                        .focused($focusedField, equals: .taskDetailsTextField)
                                        .frame(minHeight: 50)
                                        .multilineTextAlignment(.leading)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.accentColor, lineWidth: 1.5)
                                        )
                                        .onTapGesture {
                                            showDefaultDetailsText = false
                                        }
                                }
                                .padding(.bottom, 5)
                                
                                VStack(alignment: .leading) {
                                    HStack(alignment: .top) {
                                        Text("Add new task description...")
                                            .opacity(self.showDefaultDetailsText ? 0.6 : 0)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .offset(x: 5, y: 30)
                                
                            }
                            .frame(height: 200)
                            .padding(.horizontal, 15)
                            .padding(.top, 5)
                        }
                    }
                }
                .navigationBarHidden(true)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button(action: {
                                focusedField = nil
                            }) {
                                Image(systemName: "keyboard.chevron.compact.down")
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
            }
        }
        .onAppear {
            // default time currently at 10am
            taskDueDate = taskVM.defaultTime
        }
    }
    
    private func checkForEmoji() -> Bool {
        guard taskEmoji.isSingleEmoji else {
            return false
        }
        return true
    }
    
}

//struct QuickAddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickAddTaskView()
//    }
//}
