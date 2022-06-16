//
//  BannerView.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 23.03.22.
//

import SwiftUI
import SimpleToast



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
    @State var title: String
    @State var description: String
    
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    @State var showToast: Bool = false
    
    private let toastOptions = SimpleToastOptions(
        hideAfter: 5
    )
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show toast") {
                withAnimation {
                    showToast.toggle()
                }
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions) {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                Text("This is some simple toast message.")
            }
            .padding()
            .background(Color.red.opacity(0.8))
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }
        
        //        VStack {
        //            HStack {
        //                Spacer(minLength: 15)
        //
        //                VStack(alignment: .center) {
        //                    Text(title)
        //                        .font(.title3)
        //                        .bold()
        //                        .foregroundColor(.primary)
        //                    Divider()
        //                    Text(description)
        //                        .font(.headline)
        //                        .bold()
        //                        .foregroundColor(.primary)
        //                }
        //
        //                Spacer()
        //            }
        //            .frame(maxWidth: .infinity)
        //            .frame(height: 85)
        //            .background(secondaryAccentColor)
        //            .foregroundColor(Color.primary)
        //            .clipShape(RoundedRectangle(cornerRadius: 20))
        //            .cornerRadius(20)
        //            .background(
        //                RoundedRectangle(cornerRadius: 20)
        //                    .stroke(Color.accentColor, lineWidth: 3))
        //            .padding(.horizontal)
        //            .shadow(
        //                color: Color.black.opacity(0.7),
        //                radius: 30,
        //                x: 0,
        //                y: 30)
        //            .offset(y: -5)
        //
        //            Spacer()
        //        }
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
        BannerView(title: "BannerTitle", description: "Banner Description")
            .preferredColorScheme(.dark)
    }
}
