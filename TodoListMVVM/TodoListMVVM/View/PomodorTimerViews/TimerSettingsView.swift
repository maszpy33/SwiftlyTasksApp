//
//  TimerSettingsView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 04.03.22.
//

import SwiftUI

struct TimerSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userVM: UserViewModel
    
    var body: some View {
        Text("🃏 Timer Settings comming soon")
    }
}

struct TimerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSettingsView(userVM: UserViewModel())
    }
}
