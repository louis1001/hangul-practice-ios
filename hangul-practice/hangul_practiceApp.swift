//
//  hangul_practiceApp.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 16/11/22.
//

import SwiftUI

@main
struct hangul_practiceApp: App {
    @StateObject private var storeKitViewModel = StoreKitViewModel()
    @State private var storeKitTaskHandler: Task<Void, Error>?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeKitViewModel)
                .onAppear {
                    Task {
                        try await storeKitViewModel.fetchProducts()
                        
                        storeKitTaskHandler = storeKitViewModel.listenForStoreKitUpdates()
                    }
                }
        }
    }
}
