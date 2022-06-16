//
//  TimerClass.swift
//  SwiftlyTasks
//
//  Created by Andreas Zwikirsch on 07.06.22.
//

import Foundation


final class TimerViewModel: UserViewModel {
    
    @Published var overallTime: Int32 = 0
    
    override init() {
        super.init()
        
    }
    
}
