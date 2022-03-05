//
//  SettingsView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @ObservedObject var userVM: UserViewModel
    
    @State private var newUserName: String = "UserName"
    @State private var newThemeColor: String = "yellwo"
    @State private var newTaskOverdueLimit: String = "100"
    
    var user = User(userName: "", taskOverdueLimit: 3, themeColor: "", profileImage: UIImage(named: "JokerCodeProfile")!)
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                            Text("User Name:")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.primary)
                                .padding(.top, 15)
                                .labelStyle(.titleOnly)

                            Text("\(newUserName)")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                                .padding()
                        }
                        
                        VStack {
                            Image(systemName: "123.rectangle")
                                .font(.title2)
                                .foregroundColor(.primary)
                            Text("Overdue Limit:")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.primary)
                                .padding(.top, 15)
                            
                            Text("\(newTaskOverdueLimit)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.accentColor)
                                .padding()
                        }
                    }
                    
                    TextField("\(newUserName)", text: $newUserName)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                    //                        .padding(.leading)
                        .frame(height: 55)
                        .background(Color.secondary)
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                    
                    Picker("Task Overdue Days", selection: $newTaskOverdueLimit) {
                        ForEach(1 ..< 100) {
                            Text("\($0) days")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
//                    TextField("\(newTaskOverdueLimit)", text: $newTaskOverdueLimit)
//                        .multilineTextAlignment(.center)
//                        .font(.title2)
//                        .frame(height: 55)
//                        .background(Color.secondary)
//                        .foregroundColor(.primary)
//                        .cornerRadius(10)
//                        .padding(.horizontal, 10)
//                        .keyboardType(.numberPad)
//                        .onReceive(Just(newTaskOverdueLimit)) { newValue in
//                            let filtered = newValue.filter { "0123456789".contains($0) }
//                            if filtered != newValue {
//                                self.newTaskOverdueLimit = filtered
//                            }
//                        }
                    
                    // SAVE BUTTON
                    Button(action: {
                        // check if input is valid
                        guard !newUserName.isEmpty else {
                            self.errorTitle = "input error"
                            self.errorMessage = "Pleace enter a user name"
                            self.showAlert = true
                            return
                        }
                        
                        // ADD NEW TASK
                        userVM.updateUserEntity(userName: newUserName, taskOverdueLimit: Int16(newTaskOverdueLimit) ?? 14, themeColor: newThemeColor)
                        
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
                        //                            .padding(10)
                    })
                        .padding()
                }
                .padding(.horizontal, 10)
            }
            .navigationTitle("⚙️ Settings")
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userVM: UserViewModel()).preferredColorScheme(.dark)
    }
}
