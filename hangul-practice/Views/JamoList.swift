//
//  JamoList.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

struct JamoListSection: View {
    var jamo: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Jamo")
                .font(.headline)
                .padding(.horizontal, 35)
                .foregroundColor(Color("SecondaryTextColor"))
            
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        Text(" ")
                            .bold()
                            .padding()
                            .frame(width: 0)
                            .cornerRadius(5)
                            .hidden()
                        
                        ForEach(jamo, id: \.self) { char in
                            Text(char)
                                .bold()
                                .padding()
                                .background(Color.secondary.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}
