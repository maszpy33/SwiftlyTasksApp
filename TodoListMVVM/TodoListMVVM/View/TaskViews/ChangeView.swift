//
//  ChangeView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 16.02.22.
//

import SwiftUI

struct ChangeView: View {
    
    @ObservedObject var taskVM: TaskViewModel
    
    @Binding var taskTitleTextField: String
    @Binding var taskDetailsTextField: String
    @Binding var taskCategory: String
    @Binding var taskCategroySymbol: String
    @Binding var taskDueDate: Date
    @Binding var taskPriority: String
    @Binding var taskStatus: Bool
    
    
    var body: some View {
        // TITLE
        VStack {
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
            
            HStack {
                // CATEGORY
                Picker(selection: $taskCategory,
                       label:
                        Text("\(taskCategory)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                ) {
                    ForEach(taskVM.taskCategoryOptions, id: \.self) {
                        Text($0.capitalized)
                    }
                }
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(10)
                //                        .padding(5)
                .pickerStyle(.menu)
                
                // CATEGORY SYMBOL
                
                // DATE
                Picker(selection: $taskCategroySymbol,
                       label:
                        Text("\(taskCategory)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                ) {
                    ForEach(taskVM.taskCategorySymboleOptions.reversed(), id: \.self) {
                        Image(systemName: $0)
                    }
                }
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(10)
                //                        .padding(5)
                .pickerStyle(.menu)
            }
            
            DatePicker("no label", selection: $taskDueDate, in: Date()..., displayedComponents: .date)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(10)
            //                            .padding(5)
                .pickerStyle(.menu)
                .labelsHidden()
            
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
                    .stroke(taskVM.styleForPriority(taskPriority: taskPriority), lineWidth: 4))
            .cornerRadius(10)
            //                    .padding(10)
            .pickerStyle(.segmented)
        }
        .padding(.vertical, 15)
    }
}

//struct ChangeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeView()
//    }
//}
