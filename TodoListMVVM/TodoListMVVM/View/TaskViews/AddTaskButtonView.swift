//
//  AddButtonView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 13.05.22.
//

import SwiftUI


struct ScaleButtonPress: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

struct AddTaskButtonView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    
//    @Binding var focusHiddenTextField: Bool
    @State var focusFieldChange = false
    
    let secondaryAccentColor = Color("SecondaryAccentColor")
    @State private var showAddView = false
    @State private var xPos: Double = 0.0
    @State private var yPos: Double = 0.0
    @State private var scaleSize: Double = 1.0
    
    var body: some View {
        
        Button(action: {
            withAnimation(.easeOut(duration: 1.5)) {
//                xPos += 50
//                yPos -= 100
                showAddView = true
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(secondaryAccentColor)
                    .shadow(
                        color: Color.black.opacity(0.7), radius: 10,
                        x: 0,
                        y: 10)
//                    .scaleEffect(self.showAddView ? 100.0 : 1.0)
                
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .padding(5)
//                    .scaleEffect(self.showAddView ? 100.0 : 1.0)
            }
            .frame(width: 55, height: 55)
            .offset(x: showAddView ? 100 : 0, y: 0)
        }
        .sheet(isPresented: $showAddView) {
            QuickAddTaskView()
                .environmentObject(taskVM)
        }
        .onAppear {
            xPos = 0.0
            yPos = 0.0
            scaleSize = 0.0
            withAnimation(.easeOut(duration: 1.5)) {
                showAddView = false
            }
        }
    }
}

//struct AddTaskButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskButtonView()
//    }
//}
