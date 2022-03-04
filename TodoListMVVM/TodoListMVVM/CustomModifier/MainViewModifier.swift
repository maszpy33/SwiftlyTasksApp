//
//  MainViewModifier.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 12.02.22.
//

import Foundation
import SwiftUI


//struct MainViewModifier : ViewModifier {
//
//    @ObservedObject var taskVM : TaskViewModel
//
//    func body(content : Content) -> some View {
//
//        content
//            .navigationBarTitle("My Tasks")
//            .navigationBarItems(trailing: HStack(spacing:30){
//                EditButton()
//                    .disabled(taskVM.tasks.isEmpty)
//                Button(
//                    action : { taskVM.isPresented.toggle()},
//                    label: {
//                        Image(systemName: "plus")
//                            .imageScale(.large)
//                    })
//            })
//            .onChange(of: taskVM.sortType, perform: { _ in
//                guard !taskVM.tasks.isEmpty else { return }
//                withAnimation() {taskVM.sort()}
//            })
//            .fullScreenCover(isPresented: $taskVM.isPresented, content: {
//                AddTaskView(taskVM: taskVM)
//            })
//    }
//}
