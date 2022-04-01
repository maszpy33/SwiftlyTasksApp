//
//  SettingsView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import SwiftUI
import Combine
import UserNotifications


struct SettingsView: View {
    
    @ObservedObject var userVM: UserViewModel
    
    @State private var newUserName: String = "UserName"
    @State private var newThemeColor: String = "yellwo"
    @State private var newTaskOverdueLimit: String = "99"
    @State private var newTimerDuration: Int16 = 25
    @State private var newTimerBreakDuration: Int16 = 5
    @State private var newTimerRounds: Int16 = 5
    
    var user = User(userName: "", taskOverdueLimit: 3, themeColor: "", profileImage: UIImage(named: "JokerCodeProfile")!, timerDuration: 25, timerBreakDuration: 5, timerRounds: 5)
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    //NOTIVICATION BANNER
    @State var showBanner = false
    let bannerViewOffset: CGFloat = -300.0
    let bannerViewDefaultPos: CGFloat = -10.0
    let bannerSaveDataTitle = "💾 ✅ Saved Succesfully"
    let bannerSaveDataDescription = "your user settings have been updated"
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack {
                        VStack {
                            Divider()
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                                
                                Text("User Name:")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .labelStyle(.titleOnly)
                                
                                Spacer(minLength: 25)
                                
                                TextField("\(newUserName)", text: $newUserName)
                                    .multilineTextAlignment(.center)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2))
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "123.rectangle")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                                
                                Text("Overdue Limit:")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                TextField("\(newTaskOverdueLimit)", text: $newTaskOverdueLimit)
                                    .multilineTextAlignment(.center)
                                    .font(.title3)
                                    .frame(width: 70, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2))
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
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            
                            Divider()
                            
                            NotificationCenterView()
                            
                            Divider()
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
                            
                            // SAVE USER SETTINGS
                            userVM.updateUserEntity(userName: newUserName, taskOverdueLimit: Int16(newTaskOverdueLimit) ?? 99, themeColor: newThemeColor, duration: Int16(newTimerDuration), breakDuration: Int16(newTimerBreakDuration), rounds: Int16(newTimerRounds))
                            
//                            self.errorTitle = "✅ Settings Saved"
//                            self.errorMessage = "your data hase been updated"
//                            self.showAlert = true
                            
                            withAnimation(.default) {
                                self.showBanner = true
                                self.dismissBanner()
                            }
                            
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
                }
                .padding(.horizontal, 15)
                
                // BANNERVIEW
                BannerView(title: bannerSaveDataTitle, description: bannerSaveDataDescription)
                    .offset(x: 0, y: showBanner ? bannerViewDefaultPos : bannerViewOffset)
                
            }
            .navigationBarItems(leading:
                                    HStack {
                Image(systemName: "gear")
                Text("User Settings")
                
                Spacer()
            }
                                    .font(.headline)
                                    .foregroundColor(.accentColor)
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 10)
            )
        }
        .onAppear {
            if !userVM.savedUserData.isEmpty {
                let currentUser = userVM.savedUserData.first!
                newUserName = currentUser.wUserName
                newTaskOverdueLimit = String(currentUser.taskOverdueLimit)
                newThemeColor = currentUser.wThemeColor
                newTimerDuration = currentUser.timerDuration
                newTimerBreakDuration = currentUser.timerBreakDuration
                newTimerRounds = currentUser.timerRounds
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func dismissBanner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.default) {
                showBanner = false
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userVM: UserViewModel())
            .preferredColorScheme(.dark)
    }
}
