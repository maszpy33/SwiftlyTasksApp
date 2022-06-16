//
//  AddListView.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 14.06.22.
//

import SwiftUI

struct AddListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var listVM: ListViewModel
//    @EnvironmentObject var taskVM: TaskViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    // LIST VARIABLES
    @State private var newListIcon: String = "leaf"
    @State private var newListTitle: String = ""
    @State private var newListColor: String = "purple"
    
    // ERROR VARIABLES
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    @State private var showDefaultTextListTitle: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("List Icon:")
                            .font(.subheadline)
                            .padding(.leading, 5)
                        
                        ZStack {
                            Picker("", selection: $newListIcon) {
                                ForEach(listVM.listIconOptions, id: \.self) { icon in
                                    Image(systemName: icon)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 2))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("List Color:")
                            .font(.subheadline)
                            .padding(.leading, 5)
                        
                        Picker("", selection: $newListColor) {
                            ForEach(listVM.colorPlate, id: \.self) { color in
                                Text(color.capitalized)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentColor, lineWidth: 2))
                    }
                }
                
                TextField("list Title...", text: $newListTitle)
                    .padding(.horizontal, 10)
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.accentColor, lineWidth: 4))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                
                
                // SAVE BUTTON
                Button(action: {
                    // check if input is valid
                    guard !newListTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        self.errorTitle = "Input Error"
                        self.errorMessage = "Pleace enter a title to save the task!"
                        self.showAlert = true
                        return
                    }
                    
                    listVM.saveNewListEntity(listTitle: newListTitle, listIcon: newListIcon, listColor: newListColor)
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
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
                                .stroke(Color.accentColor, lineWidth: 4))
                        .cornerRadius(10)
                })
                .disabled(newListTitle.isEmpty)
                
                Spacer()
            }
            .padding(15)
            .accentColor(listVM.listColor(colorPick: newListColor))
        }
    }
}
//
//struct AddListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddListView()
//    }
//}
