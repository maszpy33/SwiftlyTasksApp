//
//  PomodoroView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import SwiftUI
import NotificationCenter


struct PomodoroView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var notifyManager: NotificationManager
    
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var taskVM: TaskViewModel
    //    @StateObject var nm = NotificationManager()
    
    // SETTINGS TIMER VARIABLES
    @State var newDuration: Int32 = 25
    @State var newBreakDuration: Int32 = 5
    @State var newRounds: Int32 = 8
    
    // RUNNING TIMER VARIABLE
    @State var userTimerDuration: Int32 = 1500
    @State var userBreakDuration: Int32 = 300
    @State private var isBreak: Bool = true
    @State private var roundsCounter: Int32 = 0
    @State private var overallSecondsCounter: Int32 = 0
    @State private var passedFocusTime: Double = 0
    
    
    // TIMER PROPERTIES
    @State var isTimerStarted = false
    @State var pausePressed: Bool = false
    @State var to: CGFloat = 0
    @State var circleRange: CGFloat = 0
    @State var currentTimeDuration: Int32 = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showSettingsView: Bool = false
    @State private var saveCurrentTime: DispatchTime = DispatchTime.now()
    
    @State private var currentUserName: String = "UserName"
    
    @State private var showingConfirmationAlert = false
    
    @State var showQuickEditView = false
    
    // NOTIFICATION VARIABLES
    @State private var notificationTitle: String = ""
    @State private var notificationSubtitle: String = ""
    
    // TIMER TEXT VARIABLES
    let bannerSaveDataTitle = "⏰ Timer is up"
    let bannerSaveDataDescription = "finished focus, take a break"
    
    // DEVELOPMENT VARIABLES
    let subTimerDuration: Int32 = 0
    let subBreakDuration: Int32 = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Color(red: 0.1, green: 0.1, blue: 0.1)
                userVM.secondaryAccentColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Spacer()
                    
                    ZStack {
                        // CIRCLE ANIMATION OF TIMER
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.accentColor.opacity(0.2), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: circleRange, height: circleRange)
                        Circle()
                            .trim(from: 0, to: to)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: circleRange, height: circleRange)
                            .rotationEffect(.init(degrees: -90))
                            .opacity(isTimerStarted ? 1 : 0)
                        
                        VStack {
                            // SHOW CURRENT TIMER
                            if pausePressed {
                                Text("Paused")
                                    .font(.custom("Avenir", size: 65))
                                    .fontWeight(.bold)
                                
                                Text("\(currentTimeDuration, specifier: formatTime())")
                                    .font(.custom("Avenir", size: 25))
                                    .fontWeight(.bold)
                            } else {
                                Text("\(currentTimeDuration, specifier: formatTime())")
                                    .font(.custom("Avenir", size: 65))
                                    .fontWeight(.bold)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.default) {
                                self.showQuickEditView = true
                            }
                        }
                    }//
                    
                    if isTimerStarted {
                        if pausePressed {
                            
                            // *********************
                            // ** CONTINUE BUTTON **
                            // *********************
                            Button(action: {
                                
                                pausePressed = false
                                
                            }) {
                                HStack(spacing: 15) {
                                    Text("Continue")
                                        .bold()
                                        .font(.title)
                                        .foregroundColor(.primary)
                                        .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                                }
                                .padding(.vertical)
                            }
                            .padding(.top, 55)
                            .buttonStyle(DefaultButtonStyle())
                            
                        } else {
                            HStack(spacing: 20) {
                                
                                // ********************
                                // *** PAUSE BUTTON ***
                                // ********************
                                Button(action: {
                                    
                                    pausePressed = true
                                    
                                }) {
                                    HStack(spacing: 15) {
                                        Text("Pause")
                                            .foregroundColor(.primary)
                                            .bold()
                                            .font(.title)
                                            .frame(width:(UIScreen.main.bounds.width / 2) - 55)
                                    }
                                    .padding(.vertical)
                                }
                                .buttonStyle(DefaultButtonStyle())
                                
                                // ********************
                                // *** QUIT BUTTON ****
                                // ********************
                                Button(action: {
                                    
                                    withAnimation(.linear) {
                                        showingConfirmationAlert = true
                                    }
                                    
                                    pausePressed = true
                                    
                                }) {
                                    HStack(spacing: 15) {
                                        Text("Quit")
                                            .foregroundColor(.primary)
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
                        
                        // ********************
                        // *** START BUTTON ***
                        // ********************
                        Button(action: {
                            
                            self.isTimerStarted = true
                            // FOR DEVELOPMENT ONLY
                            self.currentTimeDuration -= subTimerDuration
//                            self.isBreak = true
                            
                        }) {
                            HStack(spacing: 15) {
                                Text("Start")
                                    .foregroundColor(.primary)
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
                    
                    // SUMMARY OF TIMER SETTINGS [Duration, Break, Rounds]
                    HStack {
                        Text("Focus: \(newDuration)min | Break: \(newBreakDuration)min | Rounds: \(roundsCounter)/\(newRounds)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .opacity(0.8)
                    }
                    .padding(.bottom, 15)
                }
                // ASK FOR PERMISSION TO TERMINATE AN RUNNING TIMER
                .alert("Stop Current Timer", isPresented: $showingConfirmationAlert) {
                    Button("Stop") {
                        isTimerStarted = false
                        isBreak = true
                        roundsCounter = 0
                    }
                    Button("Continue", role: .cancel) {
                        pausePressed = false
                    }
                } message: {
                        Text("Really want to quit the\nrunning timer?")
                }
                
                // show QuickEditTimerView to change timer duration
                if self.showQuickEditView {
                    Color.black
                        .edgesIgnoringSafeArea(.all).opacity(0.35)
                        .onTapGesture {
                            self.showQuickEditView = false
                        }
                    VStack(alignment: .center) {
                        Spacer()
                        HStack {
                            Spacer()
                            QuickEditTimerView(showQuickEditView: $showQuickEditView, newDuration: $newDuration)
                                .environmentObject(userVM)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .accentColor(userVM.colorTheme(colorPick: userVM.savedUserData.first?.wThemeColor ?? "purple"))
            .onReceive(self.time, perform: { _ in
                // CALCULATE THE REMAINING TIME OF THE TIMER
                if self.isTimerStarted {
                    // if timer is up
                    if self.currentTimeDuration > 0 {
                        // if pause is NOT pressed, reduce currentTimerDuration by 1
                        if !self.pausePressed {
                            self.currentTimeDuration -= 1
                            self.overallSecondsCounter += 1
                            
                            print("overalltime: \(overallSecondsCounter)")
                            print("curentUserTime: \(currentTimeDuration)")
                            
                            withAnimation(.default) {
                                self.to = 1 - CGFloat(self.currentTimeDuration) / CGFloat(self.isBreak ? self.userBreakDuration : self.userTimerDuration)
                            }
                        }
                        // else do nothing
                    } else {
                        // if timer = 0 and isBreak==false assign duration to breakDuration
                        if isBreak {
                            isBreak = false
                            currentTimeDuration = userBreakDuration
                            // FOR DEVELOPMENT ONLY
//                            currentTimeDuration -= subBreakDuration
                            self.to = 0
                            
                            roundsCounter += 1
                            if roundsCounter == newRounds {
                                self.notificationTitle = "🥳 Yeah you finished your focus goal!"
                                self.notificationSubtitle = "You have done \(roundsCounter) Rounds of a \(newRounds)min focus period"
                                isTimerStarted = false
                                isBreak = true
                                roundsCounter = 0
                            } else {
                                self.notificationTitle = "☑️ \(roundsCounter).Round is done"
                                self.notificationSubtitle = "Take a \(newBreakDuration)min break!"
                            }
                        } else if !isBreak {
                            isBreak = true
                            currentTimeDuration = userTimerDuration
                            // FOR DEVELOPMENT ONLY
//                            currentTimeDuration -= subTimerDuration
                            self.to = 0
                            
                            self.notificationTitle = "🧠 Back to Work!"
                            self.notificationSubtitle = "Focus for \(newDuration)min"
                        }
                        
                        // User Notification when timer is up
                        //                        timerNotification(focusTime: Double(self.isBreak ? newDuration : newBreakDuration))
                        notifyManager.createTimerNotification(focusTime: Int(self.isBreak ? newDuration : newBreakDuration), title: notificationTitle, subtitle: notificationSubtitle, categoryIdentifier: "ACTION", inXSeconds: 1.0)
                    }
                    // else stats back to start
                } else {
                    
                    self.currentTimeDuration = userTimerDuration
                    self.to = 0
                    self.pausePressed = false
                    // newDuration is saved in minutes
                    self.userTimerDuration = newDuration * 60
                    self.overallSecondsCounter = 0
                }
            })
            .navigationTitle(self.isBreak ? "🧠 Focus Timer" : "⏸ Break Timer")
            .navigationBarItems(leading:
                                    Button(action: {
                print("change profile picture")
            }) {
                HStack {
                    ProfileView(userVM: userVM)
                    Text("\(currentUserName)")
                        .font(.headline)
                }
            },
                                trailing:
                                    HStack {
                NavigationLink(destination: TimerSettingsView(newDuration: $newDuration, newBreakDuration: $newBreakDuration, newRounds: $newRounds)
                    .environmentObject(userVM)) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.accentColor)
                            Text("Settings")
                                .font(.title2)
                                .bold()
                        }
                    }
            }
                                
            )
        }
        .onAppear {
            // FIXME: if is unnecassary, because of the ! in currentUserName
            currentUserName = userVM.savedUserData.first!.wUserName
            
            withAnimation(.easeOut) {
                self.circleRange = 280
            }
            
            // so newDuration is only changed, when save button is pressed
            // otherwise, set newDuration to current userTimerDuration
            if !userVM.savedUserData.isEmpty {
                let currentUser = userVM.savedUserData.first!
                self.userTimerDuration = currentUser.timerDuration * 60
                self.userBreakDuration = currentUser.timerBreakDuration * 60
                // newDuration and newBreakDuration is saved in minutes
                self.newBreakDuration = currentUser.timerBreakDuration
                self.newRounds = currentUser.timerRounds
                self.newDuration = currentUser.timerDuration
            }
        }
        .onChange(of: scenePhase) { newPhase in
            // keep track of time, when app moves to background
            if newPhase == .active {
                if isTimerStarted && !pausePressed {
                    print("Previous Time: \(self.currentTimeDuration)")
                    calculatePassedTime()
                    print("Time Now: \(self.currentTimeDuration)")
                }
                print("Active Main View")
                
            } else if newPhase == .inactive {
                print("Inactive Main View")
                
            } else if newPhase == .background {
                saveCurrentTime = DispatchTime.now()
                print("Background Main View")
            }
        }
    }
    
//    private func calculatePassedTimeOLD() {
//        // if app moves to background the remaining time is and current time are saved
//        // when usere opens app again, the new current time is subtracted by the saved time, when
//        // the app whent to the background -> subtract differens from time remaining
//        let start = saveCurrentTime
//
//        let end = DispatchTime.now()
//        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
//        let passedSeconds = Double(nanoTime) / 1_000_000_000
//
//        guard passedSeconds > 0 else {
//            currentTimeDuration = 0
//            return
//        }
//
//        self.currentTimeDuration = self.currentTimeDuration - Int32(passedSeconds)
//
//        // check if time is below 0
//        guard currentTimeDuration > 0 else {
//            isTimerStarted = false
//            return
//        }
//    }
    
    private func calculatePassedTime() {
        // if pause is pressed just return
        guard !pausePressed else {
            return
        }
        
        // else calculate passed time
        let start = saveCurrentTime
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let passedSeconds = Double(nanoTime) / 1_000_000_000
//        print("passedSeconds: \(passedSeconds)")
//
//        print("overalltime: \(passedSecondsOverall)")
//        print("curentUserTime: \(currentTimeDuration)")
        
        passedFocusTime = passedSeconds + Double(overallSecondsCounter)
        
        let sumTimeSession = Double((userTimerDuration + userBreakDuration) * newRounds)
//        print("sumTimeSession: \(sumTimeSession)")
        
        let remainingTime = sumTimeSession - passedFocusTime
//        print("remainingTime: \(remainingTime)")
        
        guard remainingTime > 0 else {
            isTimerStarted = false
            currentTimeDuration = 0
            roundsCounter = newRounds
            overallSecondsCounter = 0
            return
        }
        
        // if in first focus duration
        guard passedFocusTime > Double(userTimerDuration) else {
            currentTimeDuration = userTimerDuration - Int32(passedFocusTime)
            overallSecondsCounter = overallSecondsCounter + Int32(passedSeconds)
            return
        }
        // if in first break break
        guard passedFocusTime > Double(userTimerDuration + userBreakDuration) else {
            currentTimeDuration = userTimerDuration + userBreakDuration - Int32(passedFocusTime)
            roundsCounter += 1
            overallSecondsCounter = overallSecondsCounter + Int32(passedSeconds)
            isBreak = false
            return
        }
        
        // PASSED TIME IS LESS THAN ALL AND MORE THAN ON ROUND INCLUDING BREAK
        
        var passedRounds = (passedFocusTime / Double(userTimerDuration + userBreakDuration)).rounded(.down)
        print("passedRounds: \(passedRounds)")
        
        overallSecondsCounter = overallSecondsCounter + Int32(passedSeconds)
        
        // check if in break or in focus
        var userTimerDurationDoubleValue: Double = 0
        
        let timeLeftChecksum = Int32(passedFocusTime) % (userTimerDuration + userBreakDuration)
        print("TIME LEFT CHECKSUM: \(timeLeftChecksum)")

        // FIXME: Works up to this part, when timer duration is over the first round??????????
        
        // if in break duraiton
        if timeLeftChecksum > userTimerDuration {
            isBreak = false
            userTimerDurationDoubleValue = passedFocusTime - passedRounds * Double(userTimerDuration) - (passedRounds - 1.0) * Double(userBreakDuration)
            print("userTimerDurationDoubleValue: \(userTimerDurationDoubleValue)")
            self.currentTimeDuration = userBreakDuration - Int32(userTimerDurationDoubleValue)
            print("currentTimerDuration: \(currentTimeDuration)")
//            roundsCounter = Int32(passedRounds)
            
            self.to = 1 - CGFloat(self.currentTimeDuration) / CGFloat(self.isBreak ? self.userBreakDuration : self.userTimerDuration)
            
            passedRounds -= 1
        // if in focus duration
        } else {
            userTimerDurationDoubleValue = passedFocusTime - passedRounds * Double((userTimerDuration + userBreakDuration))
            print("userTimerDurationDoubleValue: \(userTimerDurationDoubleValue)")
            self.currentTimeDuration = userTimerDuration - Int32(userTimerDurationDoubleValue)
            print("currentTimerDuration: \(currentTimeDuration)")
//            roundsCounter = Int32(passedRounds)
            
            isBreak = true
            self.to = 1 - CGFloat(self.currentTimeDuration) / CGFloat(self.isBreak ? self.userBreakDuration : self.userTimerDuration)
        }
        
        roundsCounter = Int32(passedRounds)
        overallSecondsCounter = Int32(passedFocusTime)
    }
    
    private func formatTime() -> String {
        let minutes = Int(currentTimeDuration) / 60
        let seconds = Int(currentTimeDuration) % 60
        
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    
    //    private func timerNotification(focusTime: Double) {
    //        let content = UNMutableNotificationContent()
    //        content.title = "☑️ \(Int(focusTime/60.0))min Timer is done"
    //        content.subtitle = "Take a break!"
    //        content.sound = UNNotificationSound.default
    //
    //        // time trigger
    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: focusTime, repeats: false)
    //
    //        let request = UNNotificationRequest(identifier: UUID().uuidString,
    //                                            content: content,
    //                                            trigger: trigger)
    //
    //        UNUserNotificationCenter.current().add(request)
    ////
    ////        NotificationManager.instance.scheduleNotification()
    ////        let content = UNMutableNotificationContent()
    ////        content.title = "☑️ Focus Done"
    ////        content.subtitle = "finished your \(focusTime)min inteval"
    ////        content.sound = UNNotificationSound.default
    ////
    ////        // time trigger
    ////        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
    ////
    ////        let request = UNNotificationRequest(identifier: UUID().uuidString,
    ////                                            content: content,
    ////                                            trigger: trigger)
    ////
    ////        UNUserNotificationCenter.current().add(request)
    //    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(userVM: UserViewModel(), taskVM: TaskViewModel())
            .preferredColorScheme(.dark)
    }
}
