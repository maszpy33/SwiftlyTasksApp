//
//  PomodoroView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import SwiftUI
import Introspect

struct PomodoroView: View {
    
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var taskVM: TaskViewModel
    
    @State var isTimerStarted = false
    @State var to: CGFloat = 0
    @State var currentTimeDuration = 60
    @State var userTimerDuration = 60
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var pausePressed: Bool = false
    
    @State var circleRange: CGFloat = 0
    
    @State private var currentUserName: String = "UserName"
    
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.06)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: circleRange, height: circleRange)
                        Circle()
                            .trim(from: 0, to: self.to)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: circleRange, height: circleRange)
                            .rotationEffect(.init(degrees: -90))
                        
                        VStack {
                            Text("\(self.currentTimeDuration, specifier: formatTime())")
                                .font(.custom("Avenir", size: 65))
                                .fontWeight(.bold)
                        }
                    }//
                    
                    HStack(spacing: 20) {
                        
                        // CANCEL/RESUME BUTTON
                        Button(action: {
                            self.currentTimeDuration = userTimerDuration
                            withAnimation(.default) {
                                self.to = CGFloat(userTimerDuration)
                            }
                            
                            self.isTimerStarted.toggle()
                            
                        }) {
                            HStack(spacing: 15) {
                                Text("Cancel")
                                    .font(.title)
                                    .foregroundColor(.accentColor)
                            }
                            .padding(.vertical)
                            .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                            .background(userVM.secondaryAccentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }//
                        
                        // START/PAUSE BUTTON
                        Button(action: {
                            if self.currentTimeDuration > 0 {
                                self.currentTimeDuration -= 1
                                withAnimation(.default) {
                                    self.to -= 1
                                }
                                
                                // if timer is running just toggle pause
                                if self.isTimerStarted {
                                    self.pausePressed.toggle()
                                } else {
                                    self.isTimerStarted.toggle()
                                }
                            }
                        }) {
                            HStack(spacing: 15) {
                                if !self.pausePressed {
                                    Text(self.isTimerStarted ? "Pause" : "Start")
                                        .font(.title)
                                        .foregroundColor(self.isTimerStarted ? .accentColor : .green)
                                } else {
                                    Text(self.pausePressed ? "Resume" : "Pause")
                                        .font(.title)
                                        .foregroundColor(self.isTimerStarted ? .accentColor : .green)
                                }
                            }
                            .padding(.vertical)
                            .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                            .background(userVM.secondaryAccentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }//
                    }
                    .padding(.top, 55)
                }
            }
            .onReceive(self.time, perform: { _ in
                
                if self.isTimerStarted {
                    if self.currentTimeDuration != 0 {
                        if !self.pausePressed {
                            self.currentTimeDuration -= 1
                            withAnimation(.default) {
                                self.to = CGFloat(self.currentTimeDuration) / CGFloat(userTimerDuration)
                            }
                        }
                    }
                } else {
                    self.currentTimeDuration = userTimerDuration
                    self.to = 150
                    self.pausePressed = false
    //                self.isTimerStarted.toggle()
                }
            })
            .navigationTitle("⏰ Pomodoro Timer")
            .navigationBarItems(leading:
                                    Button(action: {
                // Add action
            }) {
                HStack {
                    ProfileView(userVM: userVM)
                    Text("\(currentUserName)")
                        .font(.headline)
                }
            },
                                trailing:
                                    HStack {
                Text("Settings")
                    .font(.title2)
                    .bold()
                
                Button(action: {
                    self.showSettingsView.toggle()
                }) {
                    Image(systemName: "gear")
                }
            }
                                    .foregroundColor(.accentColor)
            )
            .sheet(isPresented: $showSettingsView) {
                TimerSettingsView(userVM: userVM)
            }
            .onAppear {
                currentUserName = userVM.savedUserData.first!.userName ?? "UserName"
                
                withAnimation(.easeOut) {
                    self.circleRange = 280
                }
            }
        }
        .onAppear {
            
        }

    }
    
    func formatTime() -> String {
        let minutes = Int(currentTimeDuration) / 60 % 60
        let seconds = Int(currentTimeDuration) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(userVM: UserViewModel(), taskVM: TaskViewModel())
            .preferredColorScheme(.dark)
    }
}
