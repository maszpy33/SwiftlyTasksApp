//
//  NoTaskView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 17.02.22.
//

import SwiftUI

struct NoTaskView: View {
    
    @ObservedObject var taskVM: TaskViewModel
    @State private var showAddView: Bool = false
    
    @State private var animate: Bool = false
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("No tasks to do!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                    
                    Text("Are you a productive person? I think you should click the add button and add a bunch of items to your todo list!")
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: AddTaskView(taskVM: taskVM), label: {
                        Text("🃏 Add New Task")
                            .foregroundColor(.black)
                            .font(.headline)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(animate ? secondaryAccentColor : Color.accentColor)
                            .cornerRadius(10)
                        })
                        .padding(.horizontal, animate ? 30 : 60)
                        .shadow(
                            color: animate ? secondaryAccentColor.opacity(0.7) : Color.accentColor.opacity(0.7),
                            radius: animate ? 30 : 10,
                            x: 0,
                            y: animate ? 60 : 30)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .offset(y: animate ? -5 : 0)
                }
                .multilineTextAlignment(.center)
                .padding(40)
                .onAppear(perform: addAnimation)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func addAnimation() {
        guard !animate else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.5)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

struct NoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoTaskView(taskVM: TaskViewModel())
        }
        .navigationTitle("Title")
    }
}
