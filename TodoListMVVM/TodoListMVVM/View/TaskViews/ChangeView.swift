////
////  ChangeView.swift
////  TodoListMVVM
////
////  Created by Andreas Zwikirsch on 16.02.22.
////
//
//import SwiftUI
//
//struct ChangeView: View {
//    
//    @ObservedObject var taskVM: TaskViewModel
//    
//    @Binding var taskTitleTextField: String
//    @Binding var taskDetailsTextField: String
//    @Binding var taskCategory: String
//    @Binding var taskCategroySymbol: String
//    @Binding var taskDueDate: Date
//    @Binding var taskPriority: String
//    @Binding var taskStatus: Bool
//    
//    
//    var body: some View {
//        Text("ChangeView")
//    }
//}
//
//struct ChangeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeView(taskVM: TaskViewModel(), taskTitleTextField: .constant("Task Title"), taskDetailsTextField: .constant("some details"), taskCategory: .constant("private"), taskCategroySymbol: .constant("checkmark"), taskDueDate: .constant(Date()), taskPriority: .constant("low"), taskStatus: .constant(false))
//            .preferredColorScheme(.dark)
//    }
////    @Binding var taskTitleTextField: String
////    @Binding var taskDetailsTextField: String
////    @Binding var taskCategory: String
////    @Binding var taskCategroySymbol: String
////    @Binding var taskDueDate: Date
////    @Binding var taskPriority: String
////    @Binding var taskStatus: Bool
//}
