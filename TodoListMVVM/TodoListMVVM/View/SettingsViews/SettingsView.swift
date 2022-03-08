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
    @State private var newTaskOverdueLimit: String = "99"
    
    var user = User(userName: "", taskOverdueLimit: 3, themeColor: "", profileImage: UIImage(named: "JokerCodeProfile")!)
    
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
                            Image(systemName: "person.fill")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("User Name:")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .labelStyle(.titleOnly)
                            
                            Spacer()
                            
                            TextField("\(newUserName)", text: $newUserName)
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
                            
                            Text("Overdue Limit:")
                                .font(.title3)
                                .foregroundColor(.primary)
                            
                            TextField("\(newTaskOverdueLimit)", text: $newTaskOverdueLimit)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .onReceive(Just(self.newTaskOverdueLimit)) { inputNumber in
                                    
                                    self.newTaskOverdueLimit = inputNumber.filter { "0123456789".contains($0) }
                                    
                                    if inputNumber.count > 2 {
                                        self.newTaskOverdueLimit.removeLast()
                                    }
                                    if Int(inputNumber) ?? 0 < 0 {
                                        self.newTaskOverdueLimit = "0"
                                    }
                                }
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 10)
                }
                
                // SAVE BUTTON
                Button(action: {
                    // check if input is valid
                    guard !newUserName.isEmpty else {
                        self.errorTitle = "input error"
                        self.errorMessage = "Pleace enter a user name"
                        self.showAlert = true
                        return
                    }
                    
                    if newTaskOverdueLimit == "" {
                        self.newTaskOverdueLimit = "99"
                    }
                    
                    // ADD NEW TASK
                    userVM.updateUserEntity(userName: newUserName, taskOverdueLimit: Int16(newTaskOverdueLimit) ?? 99, themeColor: newThemeColor)
                    
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userVM: UserViewModel())
            .preferredColorScheme(.dark)
    }
}
