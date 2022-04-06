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
    
    @EnvironmentObject var userVM: UserViewModel
    
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
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
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
                                    .onReceive(Just(self.newDuration)) { inputNumber in
                                        
                                        //                                String(self.newDuration) = String(inputNumber).filter { "0123456789".contains($0) }
                                        newDuration = Int16(String(inputNumber).filter {
                                            "0123456789".contains($0) }) ?? 1
                                        print(newDuration)
                                        
                                        if inputNumber > 500 {
                                            self.newDuration = 500
                                        }
                                        
                                        if inputNumber <= 0 {
                                            self.newDuration = 1
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
                                
                                TextField("", value: $newBreakDuration, format: .number)
                                    .multilineTextAlignment(.center)
                                    .font(.title3)
                                    .frame(width: 70, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2))
                                    .onReceive(Just(self.newBreakDuration)) { inputNumber in
                                        
                                        newBreakDuration = Int16(String(inputNumber).filter {
                                            "0123456789".contains($0) }) ?? 1
                                        print(newDuration)
                                        
                                        if inputNumber > 999 {
                                            self.newBreakDuration = 999
                                        }
                                        
                                        if inputNumber <= 0 {
                                            self.newBreakDuration = 1
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
                                
                                TextField("", value: $newRounds, format: .number)
                                    .multilineTextAlignment(.center)
                                    .font(.title3)
                                    .frame(width: 70, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2))
                                    .onReceive(Just(self.newRounds)) { inputNumber in
                                        
                                        newRounds = Int16(String(inputNumber).filter {
                                            "0123456789".contains($0) }) ?? 1
                                        print(newRounds)
                                        
                                        if inputNumber > 999 {
                                            self.newRounds = 999
                                        }
                                        
                                        if inputNumber <= 0 {
                                            self.newRounds = 1
                                        }
                                    }
                                
                                Spacer(minLength: 10)
                            }
                        }
                        HStack {
                            // DEFAULT BUTTON
                            Button(action: {
                                // POMODORO DEFAULTS
                                self.newDuration = 25
                                self.newBreakDuration = 5
                                self.newRounds = 8
                                
                                // SAVE TIMER SETTINGS
                                userVM.updateUserEntity(userName: newUserName, taskOverdueLimit: Int16(newTaskOverdueLimit) ?? 99, themeColor: newThemeColor, duration: newDuration, breakDuration: newBreakDuration , rounds: newRounds)
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("🍅 Default")
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
                                .padding(.horizontal, 5)
                                .padding(.vertical, 25)
                            
                            // SAVE BUTTON
                            Button(action: {
                                //                        print("_______________________________")
                                //                        print("newDuration: \(newDuration)")
                                //                        print("_______________________________")
                                
                                // check if input is valid
                                guard newDuration != 0 else {
                                    self.errorTitle = "input error"
                                    self.errorMessage = "pleace enter a timer duration"
                                    self.showAlert = true
                                    return
                                }
                                guard !settingsPauseDuration.isEmpty else {
                                    self.errorTitle = "input error"
                                    self.errorMessage = "pleace enter a break duration"
                                    self.showAlert = true
                                    return
                                }
                                guard !settingsRound.isEmpty else {
                                    self.errorTitle = "input error"
                                    self.errorMessage = "pleace enter how many rounds\ntill long break"
                                    self.showAlert = true
                                    return
                                }
                                
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
                                .padding(.horizontal, 5)
                                .padding(.vertical, 25)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                }
                .padding(.horizontal, 15)
                
                //                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 10)
            //            .navigationBarTitle("")
            //            .navigationBarHidden(true)
            //            .navigationBarItems(leading:
            //
            //            )
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
//        .onAppear {
//            print("_______________________________")
//            print("ON APPEAR OF SHEET SETTINGSVIEW")
//            print("_______________________________")
//        }
        
    }
    
    //Function to keep text length in limits
    private func inputLimit(_ maxValue: Int16, _ valueInput: Int16) -> Bool {
        guard valueInput <= maxValue else {
            return false
        }
        guard valueInput != 0 else {
            return false
        }
        
        return true
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
