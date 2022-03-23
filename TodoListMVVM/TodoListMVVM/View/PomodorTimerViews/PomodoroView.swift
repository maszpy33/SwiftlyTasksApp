//
//  PomodoroView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import SwiftUI
import Introspect

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .foregroundColor(.white)
            .background(Color.accentColor.opacity(0.2))
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.accentColor, lineWidth: 0.7)
                )
    }
}


struct PomodoroView: View {
    
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var taskVM: TaskViewModel
    
    @State var isTimerStarted = false
    @State var pausePressed: Bool = false
    @State var to: CGFloat = 0
    @State var currentTimeDuration = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // USER DATA
    @State var userTimerDuration = 1500
    @State var pauseDuration = 600
    @State var rounds = 5
    
    @State var circleRange: CGFloat = 0
    
    @State private var currentUserName: String = "UserName"
    
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.accentColor.opacity(0.2), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: circleRange, height: circleRange)
                        Circle()
                            .trim(from: 0, to: self.to)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: circleRange, height: circleRange)
                            .rotationEffect(.init(degrees: -90))
                            .opacity(self.isTimerStarted ? 1 : 0)
                        
                        VStack {
                            if self.pausePressed {
                                Text("Paused")
                                    .font(.custom("Avenir", size: 65))
                                    .fontWeight(.bold)

                                Text("\(self.currentTimeDuration, specifier: formatTime())")
                                    .font(.custom("Avenir", size: 25))
                                    .fontWeight(.bold)
                            } else {
                                Text("\(self.currentTimeDuration, specifier: formatTime())")
                                    .font(.custom("Avenir", size: 65))
                                    .fontWeight(.bold)
                            }
                        }
                    }//
                    
                    if self.isTimerStarted {
                        if self.pausePressed {
                            
                            // CONTINUE BUTTON
                            Button(action: {
                                
                                self.pausePressed = false
                                
                            }) {
                                HStack(spacing: 15) {
                                    Text("Continue")
                                        .bold()
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                                }
                                .padding(.vertical)
                            }
                            .padding(.top, 55)
                            .buttonStyle(DefaultButtonStyle())
                            
                        } else {
                            HStack(spacing: 20) {
                                
                                // PAUSE BUTTON
                                Button(action: {
                                    
                                    self.pausePressed = true
                                    
                                }) {
                                    HStack(spacing: 15) {
                                        Text("Pause")
                                            .foregroundColor(.white)
                                            .bold()
                                            .font(.title)
                                            .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                                    }
                                    .padding(.vertical)
                                }
                                .buttonStyle(DefaultButtonStyle())
                                
                                // QUIT BUTTON
                                Button(action: {
                                    
                                    self.isTimerStarted = false
                                    
                                }) {
                                    HStack(spacing: 15) {
                                        Text("Quit")
                                            .foregroundColor(.white)
                                            .bold()
                                            .font(.title)
                                            .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                                    }
                                    .padding(.vertical)
                                }
                                .buttonStyle(DefaultButtonStyle())
                                
                                
                            }
                            .padding(.top, 55)
                        }
                    } else {
                        
                        // START BUTTON
                        Button(action: {

                            self.isTimerStarted = true
                            
                        }) {
                            HStack(spacing: 15) {
                                Text("Start")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.title)
                                    .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                            }
                            .padding(.vertical)
                            
                        }
                        .padding(.top, 55)
                        .buttonStyle(DefaultButtonStyle())
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Focus: \(userTimerDuration/60)min | Break: \(pauseDuration/60)min | Rounds: \(rounds)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .opacity(0.8)
                    }
                    .padding(.bottom, 15)
                }

            }
            .onReceive(self.time, perform: { _ in
                
                if self.isTimerStarted {
                    if self.currentTimeDuration != 0 {
                        if !self.pausePressed {
                            self.currentTimeDuration -= 1
                            withAnimation(.default) {
                                self.to = 1 - CGFloat(self.currentTimeDuration) / CGFloat(userTimerDuration)
                            }
                        }
                    }
                } else {
                    self.currentTimeDuration = userTimerDuration
                    self.to = 0
                    self.pausePressed = false
                    //                self.isTimerStarted.toggle()
                }
            })
            .navigationTitle("Focus Timer")
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
        }
        .onAppear {
            currentUserName = userVM.savedUserData.first!.userName ?? "UserName"
            
            withAnimation(.easeOut) {
                self.circleRange = 280
            }
            
            if !userVM.savedUserData.isEmpty {
                let currentUser = userVM.savedUserData.first!
                userTimerDuration = Int(currentUser.timerDuration) * 60
                pauseDuration = Int(currentUser.timerBreakDuration) * 60
                rounds = Int(currentUser.timerRounds)
            }
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
