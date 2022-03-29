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
    
    // TIMER VARIABLES
    @Binding var newDuration: Int16
    @Binding var newBreakDuration: Int16
    @Binding var newRounds: Int16
    
    // SETTINGS VARIABLE
    @State var settingsTimerDuration = "25"
    @State var settingsPauseDuration = "10"
    @State var settingsRound = "8"
    
    // USER VARIABLES
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
                        
                        TextField("", value: $newDuration, format: .number)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .frame(width: 70, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2))
//                            .onReceive(Just(self.settingsTimerDuration)) { inputNumber in
//
//                                self.settingsTimerDuration = inputNumber.filter { "0123456789".contains($0) }
//
//                                if inputNumber.count > 3 {
//                                    self.settingsTimerDuration.removeFirst()
//                                }
//
//                                if Int(inputNumber) ?? 0 < 0 {
//                                    self.settingsTimerDuration = "1"
//                                }
//                            }
                        
                        Text("seconds")
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
                        
                        TextField("", value: $newBreakDuration, format: .number)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .frame(width: 70, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2))
//                            .onReceive(Just(self.settingsPauseDuration)) { inputNumber in
//
//                                self.settingsPauseDuration = inputNumber.filter { "0123456789".contains($0) }
//
//                                if inputNumber.count > 3 {
//                                    self.settingsPauseDuration.removeFirst()
//                                }
//
//                                if Int(inputNumber) ?? 0 < 0 {
//                                    self.settingsPauseDuration = "1"
//                                }
//                            }
                        
                        Text("seconds")
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
                        
                        TextField("", value: $newRounds, format: .number)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .frame(width: 70, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2))
//                            .onReceive(Just(self.settingsRound)) { inputNumber in
//
//                                self.settingsRound = inputNumber.filter { "0123456789".contains($0) }
//
//                                if inputNumber.count > 3 {
//                                    self.settingsRound.removeFirst()
//                                }
//
//                                if Int(inputNumber) ?? 0 < 0 {
//                                    self.settingsRound = "1"
//                                }
//                            }
                        
                        Spacer(minLength: 10)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                }
                
                // SAVE BUTTON
                Button(action: {
                    if settingsTimerDuration == "" {
                        self.settingsTimerDuration = "25"
                    }
                    if settingsPauseDuration == "" {
                        self.settingsPauseDuration = "10"
                    }
                    if settingsRound == "" {
                        self.settingsRound = "5"
                    }
                    
                    newDuration = (Int16(self.settingsTimerDuration) ?? 25) * 60
                    newBreakDuration = (Int16(self.settingsPauseDuration) ?? 10) * 60
                    newRounds = (Int16(self.settingsRound) ?? 8)
                    
                    // SAVE TIMER SETTINGS
                    userVM.updateUserEntity(userName: newUserName, taskOverdueLimit: Int16(newTaskOverdueLimit) ?? 99, themeColor: newThemeColor, duration: newDuration, breakDuration: newBreakDuration , rounds: newRounds)
                    
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
//                self.newDuration = Int16(currentUser.timerDuration)
//                self.newBreakDuration = Int16(currentUser.timerBreakDuration)
//                self.newRounds = Int16(currentUser.timerRounds)
                
                self.settingsTimerDuration = String(self.newDuration)
                self.settingsPauseDuration = String(self.newBreakDuration)
                self.settingsRound = String(self.newRounds)
            }
        }
        
    }
    
}

//struct TimerSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewWrapperTimerSettings()
//    }
//
//    struct PreviewWrapperTimerSettings: View {
//
//        @State(initialValue: "1") var wrapperNewDuration: String
//        @State(initialValue: "2") var wrapperNewBreakDuration: String
//        @State(initialValue: "5") var wrapperNewRounds: String
//
//        var body: some View {
//            TimerSettingsView(userVM: UserViewModel(), newDuration: $wrapperNewDuration, newBreakDuration: $wrapperNewBreakDuration, newRounds: $wrapperNewRounds)
//        }
//    }
//}


//@Binding var newDuration: String = "25"
//@Binding var newBreakDuration: String = "10"
//@Binding var newRounds: String = "5"
