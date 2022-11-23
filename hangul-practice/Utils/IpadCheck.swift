//
//  IpadCheck.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

struct IpadCheck: View {
    @Binding var isIpad: Bool
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private func setIsIpad() {
        isIpad = horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        VStack {}
            .frame(width: 0, height: 0)
            .onAppear(perform: setIsIpad)
            .onChange(of: horizontalSizeClass) {_ in setIsIpad() }
            .onChange(of: verticalSizeClass) {_ in setIsIpad() }
    }
}
