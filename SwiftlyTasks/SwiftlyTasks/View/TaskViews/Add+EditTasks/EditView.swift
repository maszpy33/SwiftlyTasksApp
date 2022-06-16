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
    @EnvironmentObject var notifiyManager: NotificationManager
    
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
    @State var taskHasAlert: Bool = false
    
    // DISMISS KEYBOARD VARIABLE
    @FocusState private var focusedField: Field?
    
    // ERROR VARIABLES
    @State private var showAlert: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    // NOTIFICATION VARIABLES
    @State private var deletingTaskAlert: Bool = false
    @State private var scheduleReminderAlert: Bool = false
    @State var notificationInXSeconds: Int = 1
    @State private var taskNotificationTitle: String = ""
    @State private var taskNotificationSubtitle: String = ""
    
    // LIST VARIABLES
//    @State private var selectedList: ListItemEntity
    
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
                                .foregroundColor(.green)
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
                        
                        // PRIORITY PICKER VIEW
                        TaskPriorityPicker(taskPriority: $taskPriority)
                            .environmentObject(taskVM)
                    }
                    .padding(.horizontal, 15)
                    
                    ScrollView {
                        VStack {
                            HStack{
                                Spacer()
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
                                Label("Details", systemImage: taskHasDetails ? "note.text" : "text")
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
                                
                                // ACTIVATE TASK ALERT TOGGLE
                                Label("Alert", systemImage: "bell.square")
                                    .font(.title3)
                                    .foregroundColor(taskHasAlert ? .accentColor : .gray)
                                    .opacity(taskHasAlert ? 1.0 : 0.7)
                                    .onTapGesture {
                                        
                                        guard !taskTitleTextField.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                            self.errorTitle = "input error"
                                            self.errorMessage = "pleace enter a title to save the task"
                                            self.showAlert = true
                                            return
                                        }
                                        
                                        scheduleReminderAlert.toggle()
                                        
                                        // get seconds till duedate of event
                                        // use state variable so user do not have to press save before changing the
                                        // dateTime and set a reminder
//                                        notificationInXSeconds = taskVM.getSecondsTillDueDate(dueDate: task.wDueDate)
                                        notificationInXSeconds = taskVM.getSecondsTillDueDate(dueDate: taskDueDate)
                                        
                                        self.errorTitle = taskHasAlert ? "🔕 Remove Notification: \(notificationInXSeconds)sec" : "🔔 Add Notification: \(notificationInXSeconds)sec"
                                        self.errorMessage = taskHasAlert ? "Do you want to remove the reminded for \(taskVM.formatDate(dateToFormat: taskDueDate)) ? " : "Do you want to be reminded at \(taskVM.formatDate(dateToFormat: taskDueDate)) ? "
                                        
                                        taskNotificationTitle = "🔔 SwiftlyTasks Reminder"
                                        taskNotificationSubtitle = "\(task.wTaskEmoji): " + task.wTitle
                                    }
                                    .alert(isPresented: $scheduleReminderAlert) {
                                        Alert(
                                            title: Text(errorTitle),
                                            message: Text(errorMessage),
                                            primaryButton: .default(Text("Set Alert")) {
                                                // TOGGLE ALERT BOOL
                                                withAnimation(.linear) {
                                                    taskHasAlert.toggle()
                                                }
                                                
                                                // CREATE NOTIFICATION FOR TASK
                                                notifiyManager.createTaskNotification(inXSeconds: notificationInXSeconds, title: taskNotificationTitle, subtitle: taskNotificationSubtitle, categoryIdentifier: "ACTIONS")
                                                
                                                DispatchQueue.main.async {
                                                    // if duedate has changes, save it
                                                    if !(task.dueDate == taskDueDate) {
                                                        // SAVE CHANGES
                                                        taskVM.updateTaskEntity(taskEntity: task, newTitle: taskTitleTextField, newDetails: taskDetailsTextField, newCategory: taskCategory, newTaskEmoji: taskEmoji, newPriority: taskPriority, newDueDate: taskDueDate, newStatus: taskStatus, newHasDetails: taskHasDetails, newUIDelete: taskUIDeleted, newHasAlert: taskHasAlert)
                                                    }
                                                }
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 15)
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
//                                    taskVM.secondaryAccentColor
//                                        .edgesIgnoringSafeArea(.all)
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
                                .background(taskVM.secondaryAccentColor)
                                .frame(height: 200)
                                .padding(.horizontal, 15)
                                .padding(.top, 15)
                            }
                            
                            HStack {
                                // SAVE BUTTON
                                Button(action: {
                                    // check if input is valid
                                    guard !taskTitleTextField.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                        self.errorTitle = "Input Error"
                                        self.errorMessage = "Pleace enter a title to save the task!"
                                        self.showAlert = true
                                        return
                                    }
                                    
                                    if taskDetailsTextField == "" {
                                        taskHasDetails = false
                                    }
                                    
                                    // SAVE CHANGES
                                    taskVM.updateTaskEntity(taskEntity: task, newTitle: taskTitleTextField, newDetails: taskDetailsTextField, newCategory: taskCategory, newTaskEmoji: taskEmoji, newPriority: taskPriority, newDueDate: taskDueDate, newStatus: taskStatus, newHasDetails: taskHasDetails, newUIDelete: taskUIDeleted, newHasAlert: taskHasAlert)
                                    
                                    self.taskCountdown = taskVM.returnDaysAndHours(dueDate: taskDueDate)
                                    
//                                    taskTitleTextField = ""
                                    focusedField = nil
//                                    self.presentationMode.wrappedValue.dismiss()
                                    
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
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .disabled(taskTitleTextField.isEmpty)
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text(errorTitle),
                                        message: Text(errorMessage),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                                
                                // DELETE BUTTON
                                Button(action: {
                                    // ask user if he really wants to delete this task
                                    errorTitle = "Deleting Task"
                                    errorMessage = "do you really want to delete this task?"
                                    self.deletingTaskAlert = true
                                    
                                    // DELETING TASK: is implementet in the Alert beneth
                                    
                                }, label: {
                                    Text("Delete")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .frame(height: 55)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.accentColor.opacity(0.2))
                                        .cornerRadius(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .stroke(Color.accentColor, lineWidth: 4))
                                        .cornerRadius(10)
                                })
                                .padding(.trailing, 5)
                                .padding(.leading, 5)
                                .alert(isPresented: $deletingTaskAlert) {
                                    Alert(
                                        title: Text(errorTitle),
                                        message: Text(errorMessage),
                                        primaryButton: .destructive(Text("Delete")) {
                                            // DELETE TASK
                                            taskVM.deleteTaskEntity(with: task.id)
                                            self.presentationMode.wrappedValue.dismiss()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)

                            Spacer()
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
                    self.taskHasAlert = task.hasAlert
//                    self.selectedList = task.ofList ?? <#default value#>
                    
                    if self.taskDetailsTextField != "" {
                        self.taskHasDetails = true
                    }
                    
                    self.taskCountdown = taskVM.returnDaysAndHours(dueDate: taskDueDate)
                }
            }
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//
//    @State static var defaultIsEditView = false
//
//    static var previews: some View {
//        EditView(taskVM: TaskViewModel(), task: TaskItemEntity())
//            .preferredColorScheme(.dark)
//    }
//}
