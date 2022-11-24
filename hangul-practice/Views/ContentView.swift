//
//  ContentView.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 16/11/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var container = WordViewModel()
    
    @State private var isIpad = false
    
    @State private var showingInfo = false
    
    private var backgroundColor: Color {
        Color("BackgroundColor")
    }
    
    var body: some View {
        ZStack {
            VStack {
                IpadCheck(isIpad: $isIpad)
                
                JamoListSection(jamo: container.decomposition)
                    .padding(.top, 30)
                    .frame(maxWidth: 900)
                
                VStack(spacing: 20) {
                    Spacer(minLength: 0)
                        .frame(maxHeight: 15)
                        .layoutPriority(-1)
                    KoreanWordSection(word: container.randomWord)
                    Spacer(minLength: 0)
                        .frame(maxHeight: 15)
                        .layoutPriority(-1)
                    
                    VStack(spacing: isIpad ? 30 : 20) {
                        ActionButtonsSection(container: container)
                        
                        DetailsSection(container: container)
                    }
                    .frame(maxWidth: 600)
                }
                .padding(.horizontal, 35)
                
                Spacer()
            }
            .padding(.vertical)
            
            HStack {
                Image(systemName: "info.circle")
                    .asButton {
                        showingInfo = true
                    }
                Spacer()
            }
            .padding()
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $showingInfo) { InformationView() }
        .onAppear {
            try? container.fetchWords()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
