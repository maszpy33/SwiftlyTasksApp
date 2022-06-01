//
//  NavigaitonBarColorModifier.swift
//  TodoListMVVM
//
//  Created by Andreas Zwikirsch on 01.03.22.
//

import Foundation
import SwiftUI


//struct NavigationConfigurator: UIViewControllerRepresentable {
//    var configure: (UINavigationController) -> Void = { _ in }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
//        UIViewController()
//    }
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
//        if let nc = uiViewController.navigationController {
//            self.configure(nc)
//        }
//    }
//}

//struct NavigationBarModifier: ViewModifier {
//
//    var backgroundColor: UIColor?
//    var titleColor: UIColor?
//
//    init(backgroundColor: UIColor?, titleColor: UIColor?) {
//        self.backgroundColor = backgroundColor
//        let coloredAppearance = UINavigationBarAppearance()
//        coloredAppearance.configureWithTransparentBackground()
//        coloredAppearance.backgroundColor = backgroundColor
//        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
//        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]
//
//        UINavigationBar.appearance().standardAppearance = coloredAppearance
//        UINavigationBar.appearance().compactAppearance = coloredAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
//    }
//
//    func body(content: Content) -> some View {
//        ZStack{
//            content
//            VStack {
//                GeometryReader { geometry in
//                    Color(self.backgroundColor ?? .clear)
//                        .frame(height: geometry.safeAreaInsets.top)
//                        .edgesIgnoringSafeArea(.top)
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
//extension View {
//
//    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
//        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
//    }
//
//}
