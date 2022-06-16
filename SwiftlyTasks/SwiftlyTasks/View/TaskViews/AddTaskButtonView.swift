//
//  AddButtonView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 13.05.22.
//

import SwiftUI

struct AddTaskButtonView: View {
    @EnvironmentObject var userVM: UserViewModel
    let secondaryAccentColor = Color("SecondaryAccentColor")

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(secondaryAccentColor)
                .shadow(
                    color: Color.black.opacity(0.7), radius: 10,
                    x: 0,
                    y: 10)
            
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .padding(5)
        }
        .frame(width: 55, height: 55)
        .accentColor(userVM.colorTheme(colorPick: userVM.savedUserData.first?.wThemeColor ?? "purple"))
    }
}

//struct AddTaskButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskButtonView()
//    }
//}
