//
//  View+Extension.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

extension View {
    /// Converts a view into a button with an action
    func asButton(_ action: @escaping()->Void) -> some View {
        Button(action: action, label: { self })
    }
    
    /// Conditionally apply modifiers to this view
    @ViewBuilder
    func applyIf(_ condition: Bool, modification: (Self)->some View) -> some View {
        if condition {
            modification(self)
        } else {
            self
        }
    }
}
