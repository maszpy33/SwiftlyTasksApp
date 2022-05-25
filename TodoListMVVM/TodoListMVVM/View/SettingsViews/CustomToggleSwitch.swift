//
//  CustomToggleSwitch.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 24.05.22.
//

import SwiftUI

struct CustomToggleSwitch: View {
    
    @Binding var newSwitchUITheme: Bool
    @State private var width: CGFloat = 140
    @State private var height: CGFloat = 40
    @State private var switchWidth: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Switch Theme:")
                    .font(.title3)
                Spacer()
            }
            .padding(.horizontal, 15)
            
            ZStack {
                HStack {
                    Text("Classic")
                        .multilineTextAlignment(.center)
                        .frame(width: width)
                    Spacer()
                    Text("Alternative")
                        .multilineTextAlignment(.center)
                        .frame(width: width)
                        .padding(.trailing, 10)
                }
                .font(.system(size: 20, weight: .semibold))
                
                HStack {
                    if newSwitchUITheme {
                        Spacer()
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .opacity(0)
                        .padding()
                        .frame(width: width, height: height)
    //                    .animation(.spring(response: 0.5), value: newSwitchUITheme)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.accentColor, lineWidth: 2))
                        .cornerRadius(10)
                        .padding(.trailing, newSwitchUITheme ? 10 : 0)
                        
                    if !newSwitchUITheme {
                        Spacer()
                    }
                }
//                .padding(.horizontal, 15)
                

            }
            .onTapGesture {
                withAnimation(.spring(response: 0.5)) {
                    newSwitchUITheme.toggle()
                }
            }
            .onAppear {
                switchWidth = height
            }
        }

    }
}

//struct CustomToggleSwitch_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomToggleSwitch()
//    }
//}
