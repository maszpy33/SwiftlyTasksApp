//
//  EditView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 16.02.22.
//

import SwiftUI
import Combine


struct EditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var taskVM: TaskViewModel
    var task: TaskItemEntity
    
    @State private var addTime: Bool = true
    @State private var showDefaultDetailsText: Bool = true
    @State private var taskCountdown: String = ""
    
    // Model Variables
    @State var taskTitleTextField: String = ""
    @State var taskDetailsTextField: String = ""
    @State var taskCategory: String = "private"
    @State var taskEmoji: String = "🤷🏻‍♂️"
    @State var taskDueDate: Date = Date()
    @State var taskPriority: String = "normal"
    @State var taskStatus: Bool = false
    @State var taskHasDetails: Bool = false
    @State var taskUIDeleted: Bool = false
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                taskVM.secondaryAccentColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
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
                                
                                // update task without pressing the save button
                                // when status is changed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    taskVM.updateTaskStatus(taskEntity: task)
                                        }
                            }
                        }
                        
                        Spacer()
                        
                        // DUEDATE
                        if taskUIDeleted {
                            DatePicker("no label", selection: $taskDueDate, in: Date()...)
                                .foregroundColor(.accentColor)
                                .frame(height: 55)
                                .cornerRadius(10)
                                .pickerStyle(.menu)
                                .labelsHidden()
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
                    
                    ScrollView {
                        VStack {
                            HStack{
                                // DATE TIME TOGGLE
                                Image(systemName: "clock.fill")
                                    .font(.title3)
                                Text("Time")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.accentColor)
                                
                                // TIME TOGGLE
                                Toggle("no label", isOn: $taskUIDeleted)
                                    .tint(Color.accentColor)
                                    .labelsHidden()
                                
                                
                                Spacer()
                                
                                // SHOW DETAILS TOGGLE
                                Image(systemName: "note")
                                    .font(.title3)
                                Text("Details")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.accentColor)
                                
                                Toggle("no label", isOn: $taskHasDetails)
                                    .tint(Color.accentColor)
                                    .labelsHidden()
                                    .onReceive([self.taskHasDetails].publisher.first()) { toggleStatus in
                                        // delete task details, when detials toggle is false
                                        if !toggleStatus {
                                            taskDetailsTextField = ""
                                            showDefaultDetailsText = false
                                        }
                                        
                                        if toggleStatus && taskDetailsTextField == "" {
                                            showDefaultDetailsText = false
                                        }
                                    }
                            }
                            .padding(.horizontal, 20)
                            .foregroundColor(.accentColor)
                            
                            HStack {
                                // EMOJI INPUT
                                TextField("🤷🏻‍♂️", text: $taskEmoji)
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
                                    .font(.headline)
                                    .padding(10)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            
                            // COUNTDOWN TEXT
                            HStack {
                                Text("Countdown: ")
                                    .font(.system(.title2, design: .rounded ))
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.accentColor)
                                Text("\(taskCountdown)")
                                    .font(.system(.title2, design: .rounded ))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                            .frame(height: 55)
                            .cornerRadius(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.accentColor, lineWidth: 4))
                            .cornerRadius(10)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 15)
                            
                            // DETAILS
                            if taskHasDetails {
                                ZStack {
                                    VStack(alignment: .leading) {
                                        Text("Add Details:")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.bottom, 3)
                                        
                                        TextEditor(text: $taskDetailsTextField)
                                            .frame(minHeight: 50)
                                            .multilineTextAlignment(.leading)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.blue, lineWidth: 1.5)
                                            )
                                            .onTapGesture {
                                                showDefaultDetailsText = false
                                            }
                                    }
                                    
                                    if taskDetailsTextField == "" {
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
                                }
                                .frame(height: 200)
                                .padding(.horizontal, 15)
                                .padding(.top, 15)
                            }
                            
                            // SAVE BUTTON
                            Button(action: {
                                // check if input is valid
                                guard !taskTitleTextField.isEmpty else {
                                    self.errorTitle = "input error"
                                    self.errorMessage = "pleace enter a title to save the task"
                                    self.showAlert = true
                                    return
                                }
                                
                                if taskDetailsTextField == "" {
                                    taskHasDetails = false
                                }
                                
                                // SAVE CHANGES
                                taskVM.updateTaskEntity(taskEntity: task, newTitle: taskTitleTextField, newDetails: taskDetailsTextField, newCategory: taskCategory, newTaskEmoji: taskEmoji, newPriority: taskPriority, newDueDate: taskDueDate, newStatus: taskStatus, newHasDetails: taskHasDetails, newUIDelete: taskUIDeleted)
                                
                                taskTitleTextField = ""
                                self.presentationMode.wrappedValue.dismiss()
                                
                            }, label: {
                                Text("Save")
                                    .font(.headline)
                                    .foregroundColor(.primary)
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
                .onAppear {
                    self.taskTitleTextField = task.wTitle
                    self.taskDetailsTextField = task.wDetails
                    self.taskCategory = task.wCategory
                    self.taskEmoji = task.wTaskEmoji
                    self.taskDueDate = task.wDueDate
                    self.taskPriority = task.wPriority
                    self.taskHasDetails = task.hasDetails
                    self.taskStatus = task.status
                    self.taskUIDeleted = task.uiDeleted
                    
                    if self.taskDetailsTextField != "" {
                        self.taskHasDetails = true
                    }
                    
                    self.taskCountdown = taskVM.returnDaysAndHours(dueDate: taskDueDate)
                }
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
            .preferredColorScheme(.dark)
    }
}
