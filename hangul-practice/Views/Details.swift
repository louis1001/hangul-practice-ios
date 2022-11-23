//
//  Details.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

struct DetailsSection: View {
    @ObservedObject var container: WordViewModel
    
    @StateObject private var action = ReferenceAction()
    
    @State private var translationDeployed = true
    @State private var isIpad = false
    
    var body: some View {
        VStack(spacing: 40) {
            IpadCheck(isIpad: $isIpad)
            VStack(spacing: 2) {
                HStack {
                    Text("Definition")
                        .applyIf(isIpad) { $0.bold() }
                        .font(isIpad ? .system(size: 24) : .headline)
                    
                    Image(systemName: "chevron.forward")
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
                
//                VStack{}
//                    .frame(height: 2)
//                    .frame(minWidth: 0, maxWidth: .infinity)
//                    .background(Color.secondary)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .asButton {
                action.showDefinition(for: container.randomWord)
            }
            .disabled(!action.definitionAvailable(for: container.randomWord))
            
            VStack(spacing: 2) {
                VStack {
                    HStack {
                        Text("Translation")
                            .applyIf(isIpad) { $0.bold() }
                            .font(isIpad ? .system(size: 24) : .headline)
                        
                        Image(systemName: "chevron.forward")
                            .rotationEffect(
                                translationDeployed ? .degrees(90) : .zero
                            )
                        Spacer()
                    }
                    .foregroundColor(Color("SecondaryTextColor"))
                    .asButton {
                        withAnimation {
                            translationDeployed.toggle()
                        }
                    }
                    
                    VStack{}
                        .frame(height: 2)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.secondary)
                }
                .background(Color("BackgroundColor"))
                .zIndex(2)

                if translationDeployed {
                    VStack {
                        Text(container.translation)
                            .font(isIpad ? .system(size: 24) : .body)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                    .padding(.leading, 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                }
            }
        }
        .overlay(
            ReferenceRepresentable(action: action)
            .allowsHitTesting(false)
        )
    }
}
