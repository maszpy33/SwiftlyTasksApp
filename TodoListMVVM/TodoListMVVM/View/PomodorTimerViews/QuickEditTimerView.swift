//
//  QuickEditTimerView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 16.05.22.
//

import SwiftUI

struct QuickEditTimerView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    @Binding var newDuration: Int32
    //    @Binding var newBreakDuration: Int16
    //    @Binding var newRounds: Int16
    
    @State private var displayedDuration: String = ""
    @FocusState var focusedField: Field?
    @State private var someText: String = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                TextField("", value: $newDuration, format: .number)
                    .focused($focusedField, equals: .newDuration)
                    .font(.system(size: 25, weight: .semibold))
                    .background(Color.accentColor.opacity(0.9))
                    .cornerRadius(10)
                
                Button("Press Me") {
                    print("something happens")
                }
            }
            .padding(15)
        }
        .frame(width: 280, height: 200)
        .foregroundColor(.primary)
        .background(userVM.secondaryAccentColor)
        .cornerRadius(15)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(Color.accentColor, lineWidth: 3.0)
        )
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
    }
}

//struct QuickEditTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickEditTimerView()
//    }
//}
