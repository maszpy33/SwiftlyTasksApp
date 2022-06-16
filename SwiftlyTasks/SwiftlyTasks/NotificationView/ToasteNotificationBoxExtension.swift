//
//  ToasteNotificationBoxExtension.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 13.06.22.
//

import Foundation
import SimpleToast
import SwiftUI


struct ToastBannerView: ViewModifier {
    @Binding var showToast: Bool
    var title: String
    var description: String?
    var imageName: String?
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 4,
        backdrop: Color.black.opacity(0.2),
        animation: .easeOut,
        modifierType: .slide
    )
    
    func body(content: Content) -> some View {
        content
            .simpleToast(isPresented: $showToast, options: toastOptions) {
                HStack {
                    Image(systemName: imageName ?? "leaf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("\(title)")
                            .font(.title3)
                            .bold()
                        // if description is not nil
                        if let description = description {
                            Text(description)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .background(Color.green.opacity(0.8))
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(Color.white, lineWidth: 2))
                .cornerRadius(15)
                .shadow(color: .black, radius: 10)
                .padding(.horizontal, 20)
//
//                Spacer()
            }
    }
}
