//
//  TimerSettingsView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 04.03.22.
//

import SwiftUI
import Combine


struct TimerSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userVM: UserViewModel
    
    @State private var newDuration: String = "25"
    @State private var newBreakDuration: String = "10"
    @State private var newRounds: String = "5"
    
    @State private var newUserName = "UserName"
    @State private var newTaskOverdueLimit = "14"
    @State private var newThemeColor = "blue"
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                    VStack {
                        HStack {
                            Image(systemName: "alarm")
                            Text("Timer Settings")
                            
                            Spacer()
                        }
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "clock")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("Focus Duration:")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .labelStyle(.titleOnly)
                            
                            Spacer()
                            
                            TextField("", text: $newDuration)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .frame(width: 70, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2))
                                .onReceive(Just(self.newDuration)) { inputNumber in
                                    
                                    self.newDuration = inputNumber.filter { "0123456789".contains($0) }
                                    
                                    if inputNumber.count > 3 {
                                        self.newDuration.removeFirst()
                                    }
                                    
                                    if Int(inputNumber) ?? 0 < 0 {
                                        self.newDuration = "1"
                                    }
                                }
                            
                            Text("minutes")
                                .font(.title3)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "123.rectangle")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("Break Duration:")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            TextField("", text: $newBreakDuration)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .frame(width: 70, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2))
                                .onReceive(Just(self.newBreakDuration)) { inputNumber in
                                    
                                    self.newBreakDuration = inputNumber.filter { "0123456789".contains($0) }
                                    
                                    if inputNumber.count > 3 {
                                        self.newBreakDuration.removeFirst()
                                    }
                                    
                                    if Int(inputNumber) ?? 0 < 0 {
                                        self.newBreakDuration = "1"
                                    }
                                }
                            
                            Text("minutes")
                                .font(.title3)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "circle")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("Rounds:")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            TextField("", text: $newRounds)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .frame(width: 70, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2))
                                .onReceive(Just(self.newRounds)) { inputNumber in
                                    
                                    self.newRounds = inputNumber.filter { "0123456789".contains($0) }
                                    
                                    if inputNumber.count > 3 {
                                        self.newRounds.removeFirst()
                                    }
                                    
                                    if Int(inputNumber) ?? 0 < 0 {
                                        self.newRounds = "1"
                                    }
                                }
                            
                            Spacer(minLength: 10)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                    }
                
                // SAVE BUTTON
                Button(action: {
                    if newDuration == "" {
                        self.newDuration = "25"
                    }
                    if newBreakDuration == "" {
                        self.newDuration = "10"
                    }
                    if newRounds == "" {
                        self.newRounds = "5"
                    }
                    
                    // SAVE TIMER SETTINGS
                    userVM.updateUserEntity(userName: newUserName, taskOverdueLimit: Int16(newTaskOverdueLimit) ?? 99, themeColor: newThemeColor, duration: Int16(newDuration) ?? 25, breakDuration: Int16(newBreakDuration) ?? 5, rounds: Int16(newRounds) ?? 5)
                    
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
                                .stroke(Color.accentColor, lineWidth: 2))
                        .cornerRadius(10)
                })
                    .padding(.horizontal, 10)
                    .padding(.vertical, 25)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 10)
//            .navigationBarItems(leading:
//
//            )
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if !userVM.savedUserData.isEmpty {
                let currentUser = userVM.savedUserData.first!
                self.newUserName = currentUser.wUserName
                self.newTaskOverdueLimit = String(currentUser.taskOverdueLimit)
                self.newThemeColor = currentUser.wThemeColor
                self.newDuration = String(currentUser.timerDuration)
                self.newBreakDuration = String(currentUser.timerBreakDuration)
                self.newRounds = String(currentUser.timerRounds)
            }
        }
        
    }

}

struct TimerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSettingsView(userVM: UserViewModel())
            .preferredColorScheme(.dark)
    }
}
