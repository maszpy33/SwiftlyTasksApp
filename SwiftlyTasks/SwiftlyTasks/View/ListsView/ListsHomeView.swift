//
//  ListsHomeView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 20.05.22.
//

import SwiftUI

struct ListsHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                ForEach(1...10, id: \.self) {
                    Text("\($0).List")
                }
            }
        }
    }
}

struct ListsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ListsHomeView()
    }
}
