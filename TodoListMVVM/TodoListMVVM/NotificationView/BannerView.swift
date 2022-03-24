//
//  BannerView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 23.03.22.
//

import SwiftUI


struct BannerData {
    let title: String
    var actionTitle: String? = nil
    // Level to drive tint colors and importance of the banner.
    var level: Level = .info
    
    enum Level {
        case info
        case warning
        case success
        
        var tintColor: Color {
            switch self {
            case .info: return .blue
            case .warning: return .yellow
            case .success: return .green
            }
        }
    }
}


struct BannerView: View {
    
//    @State private var showBanner = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 15)
                
                VStack(alignment: .leading) {
                    Text("💾 ✅ Saved Succesfully")
                        .font(.title3)
                        .bold()
                    Divider()
                    Text("your user settings have been updated")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 85)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .foregroundColor(Color.primary)
            .cornerRadius(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.accentColor, lineWidth: 3))
            .padding(.horizontal)
            
            
            Spacer()
            
//            Text("Banner Animation")
//
//            Button(action: {
//                withAnimation(.default) {
//                    self.showBanner = true
//                    self.dismissBanner()
//                }
//            }) {
//                Text("Press Me\nfor Notification Banner")
//            }
//
//            Spacer()
        }
    }
    
//    private func dismissBanner() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            withAnimation(.default) {
//                showBanner = false
//            }
//        }
//    }
}
    
    
    
    struct BannerView_Previews: PreviewProvider {
        
        @State(initialValue: "Default Banner Title") var defaultTitle: String
        @State(initialValue: "Default Banner Details") var defaultDetails: String
        
        static var previews: some View {
            BannerView()
                .preferredColorScheme(.dark)
        }
    }
