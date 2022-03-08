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
    
    @State private var duration: String = "25"
    @State private var breakDuration: String = "10"
    @State private var rounds: String = "5"
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "clock")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("Focus duration:")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .labelStyle(.titleOnly)
                            
                            Spacer()
                            
                            TextField("\(duration)min", text: $duration)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                        .padding(.bottom, 10)
                        
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "123.rectangle")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("Break duration:")
                                .font(.title3)
                                .foregroundColor(.primary)
                            
                            TextField("\(breakDuration)min", text: $breakDuration)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .onReceive(Just(self.breakDuration)) { inputNumber in
                                    
                                    self.breakDuration = inputNumber.filter { "0123456789".contains($0) }
                                    
                                    if inputNumber.count > 2 {
                                        self.breakDuration.removeLast()
                                    }
                                    
                                    if Int(inputNumber) ?? 0 < 0 {
                                        self.breakDuration = "1"
                                    }
                                }
                        }
                        .padding(.bottom, 10)
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "circle")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("Rounds:")
                                .font(.title3)
                                .foregroundColor(.primary)
                            
                            TextField("\(rounds)", text: $rounds)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .onReceive(Just(self.rounds)) { inputNumber in
                                    
                                    self.rounds = inputNumber.filter { "0123456789".contains($0) }
                                    
                                    if inputNumber.count > 2 {
                                        self.rounds.removeLast()
                                    }
                                    
                                    if Int(inputNumber) ?? 0 < 0 {
                                        self.rounds = "1"
                                    }
                                }
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 10)
                }
                
                // SAVE BUTTON
                Button(action: {
                    
                    if duration == "" {
                        self.duration = "25"
                    }
                    if breakDuration == "" {
                        self.duration = "10"
                    }
                    if rounds == "" {
                        self.rounds = "5"
                    }
                    
                    // ADD NEW TASK
                    print("SAVE TIMER SETTINGS")
//                    userVM.updateUserEntity(userName: newUserName, taskOverdueLimit: Int16(newTaskOverdueLimit) ?? 99, themeColor: newThemeColor)
                    
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
                                .stroke(Color.accentColor, lineWidth: 2))
                        .cornerRadius(10)
                })
                    .padding(.horizontal, 10)
                    .padding(.vertical, 25)
                
                Spacer()
            }
            .padding(.top, 20)
//            .navigationTitle("⚙️")
            .navigationBarItems(leading:
                HStack {
                    Image(systemName: "gear")
                    Text("User Settings")
            }
            )
        }
        .onAppear {
            if !userVM.savedUserData.isEmpty {
                let currentUser = userVM.savedUserData[0]
                newUserName = currentUser.userName ?? "No Name"
                newTaskOverdueLimit = String(currentUser.taskOverdueLimit)
                newThemeColor = currentUser.themeColor ?? "yellow"
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct TimerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSettingsView(userVM: UserViewModel())
    }
}
