//
//  InformationView.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject private var storeKitViewModel: StoreKitViewModel
    
    private var darkerBackground: Color {
        colorScheme == .dark
        ? Color.black.opacity(0.1)
        : Color.black.opacity(0.04)
    }
    
    var body: some View {
        VStack {
            Text("Hangul Practice")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            
            
            VStack(alignment: .leading) {
                Text("Remember!").bold()
                    .padding(.bottom, 5)
                Text("The pronunciation suggested here **may be wrong**. This is Siri's attempt at Korean. You should look up other resources about pronunciation, or ask someone who _speaks the language_.")
            }
            .multilineTextAlignment(.leading)
            .padding()
            .background(darkerBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
            VStack(spacing: 40) {
                if storeKitViewModel.productsAvailable || storeKitViewModel.paymentSucceeded {
                    VStack(alignment: .trailing) {
                        Text("Enjoying the app?")
                            .font(.headline)
                        
                            if storeKitViewModel.paymentSucceeded {
                                Text("Thank You! ♥︎")
                                    .bold()
                                    .padding(5)
                            } else {
                            Text("Leave a tip!")
                                .bold()
                                .padding(5)
                                .asButton {
                                    storeKitViewModel.purchaseTip()
                                }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                }
                
                VStack(alignment: .leading) {
                    Text("App developed by")
                        .font(.headline)
                    (
                        Text("louis1001") +
                        Text(Image(systemName: "link"))
                    )
                    .bold()
                    .asButton {
                        UIApplication.shared.open(URL(string: "https://louis1001.dev")!)
                    }
                    .padding(.vertical, 5)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}
