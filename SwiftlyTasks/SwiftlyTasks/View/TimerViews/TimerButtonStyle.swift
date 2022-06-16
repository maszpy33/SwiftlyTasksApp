//
//  TimerButtonStyle.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 05.06.22.
//

import Foundation
import SwiftUI


struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .foregroundColor(.primary)
            .background(Color.accentColor.opacity(0.2))
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.accentColor, lineWidth: 0.7)
            )
    }
}
