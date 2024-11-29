//
//  View.swift
//  gameCompanion
//
//  Created by Dirk Boller on 07.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    /// A View wrapper to make the modifier easier to use
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }

    
    /// Causes the view to fill into its superview.
    public func _fill(alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            return self.frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: alignment
            )
        }
    }
}

