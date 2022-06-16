//
//  QuickEditTimerView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 16.05.22.
//

import SwiftUI
import Combine

struct QuickEditTimerView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    @Binding var showQuickEditView: Bool
    
    @Binding var newDuration: Int32
    @State private var quickNewDuration: String = "25"
    //    @Binding var newBreakDuration: Int16
    //    @Binding var newRounds: Int16
    
    @State private var displayedDuration: String = ""
    @FocusState var focusedField: Field?
    @State private var someText: String = ""
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    TextField("", text: $quickNewDuration)
                        .focused($focusedField, equals: .quickNewDuration)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 25, weight: .semibold))
                        .frame(width: 50)
                        .onReceive(Just(quickNewDuration)) { inputNumber in
                            //                                String(self.newDuration) = String(inputNumber).filter { "0123456789".contains($0) }
                            quickNewDuration = String(inputNumber).filter {
                                "0123456789".contains($0) }
//                            displayedDuration = String(inputNumber).filter {
//                                "0123456789".contains($0) }
                            
                            if Int32(quickNewDuration) ?? 25 > 500 {
                                quickNewDuration = "500"
                                errorTitle = "Timer input error"
                                errorMessage = "Timer maximum 500min"
                                showAlert = true
                            }
                            
                            if Int32(quickNewDuration) ?? 25 <= 0 {
                                quickNewDuration = "1"
                                errorTitle = "Timer input error"
                                errorMessage = "please provide a positiv number"
                                showAlert = true
                            }
                        }
                    Text(" minutes")
                        .font(.headline)
                        .offset(x: -10, y: 2)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.accentColor, lineWidth: 2))
                .cornerRadius(10)
                
                // SAVE BUTTON
                Button(action: {
                    // check if input is valid
                    guard newDuration != 0 else {
                        self.errorTitle = "input error"
                        self.errorMessage = "pleace enter a timer duration"
                        self.showAlert = true
                        return
                    }
                    
                    // SAVE TIMER SETTINGS
                    userVM.updateUserEntity(userName: userVM.savedUserData.first!.wUserName, taskOverdueLimit: userVM.savedUserData.first!.taskOverdueLimit, themeColor: userVM.savedUserData.first!.wThemeColor, duration: Int32(quickNewDuration) ?? 25, breakDuration: userVM.savedUserData.first!.timerBreakDuration , rounds: userVM.savedUserData.first!.timerRounds, switchUITheme: userVM.savedUserData.first!.switchUITheme)
                    
                    self.newDuration = Int32(quickNewDuration) ?? 25
                    self.showQuickEditView = false
                    
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
                .disabled(quickNewDuration.isEmpty)
            }
            .padding(15)
        }
        // FIXME: App crashs when ! operator is used instead of ?
        .accentColor(userVM.colorTheme(colorPick: userVM.savedUserData.first?.wThemeColor ?? "purple"))
        .frame(width: 280, height: 160)
        .foregroundColor(.primary)
        .background(userVM.secondaryAccentColor)
        .cornerRadius(15)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(Color.accentColor, lineWidth: 6)
        )
        .onAppear {
            quickNewDuration = String(newDuration)
        }
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

//struct QuickEditTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickEditTimerView()
//    }
//}
