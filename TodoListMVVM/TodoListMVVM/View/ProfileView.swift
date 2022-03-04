//
//  ProfilView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 19.02.22.
//

import SwiftUI


struct ProfileView: View {

    @State private var image = UIImage()
    @State private var showSheet = false
    
    @ObservedObject var userVM: UserViewModel

    var body: some View {
        
//        HStack {
            Image(uiImage: self.image)
                    .resizable()
                    .cornerRadius(20)
                    .padding(.all, 4)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .onTapGesture {
                        showSheet = true
//                    }
//            Text("JokerCode")
//                .font(.headline)
//            Text("\(userVM.savedUserData[0].userName ?? "JokerCode")")
//                .font(.headline)
//
//            Text("Select Photo")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 50)
//                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
//                    .cornerRadius(16)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .onTapGesture {
//                        showSheet = true
//                    }
        }
        .padding(.horizontal, 1)
        .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .onAppear {
            image = UIImage(named: "JokerCodeProfile")!
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userVM: UserViewModel())
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .previewDisplayName("Profile View")
    }
}
