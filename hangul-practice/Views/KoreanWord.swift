//
//  KoreanWord.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

struct KoreanWordSection: View {
    var word: String
    @State private var shareText: ShareText?
    @State private var isIpad = false
    
    var body: some View {
        IpadCheck(isIpad: $isIpad)
        Group {
            if word.isEmpty {
                VStack {
                    Text(" ")
                }
                    .padding()
                    .frame(width: 200)
                    .cornerRadius(55)
                    .background(Color.gray.opacity(0.5))
            } else {
                HStack {
                    // So that the text container doesn't shrink
                    // when the font size does
                    Text(" ").padding().frame(width: 0)
                    
                    Text(word)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding()
                        .contextMenu {
                            Label("Copy word", systemImage: "doc.on.doc")
                                .asButton {
                                    UIPasteboard.general.string = word
                                }
                            
                            Label("Share", systemImage: "square.and.arrow.up")
                                .asButton {
                                    shareText = ShareText(text: word)
                                }
                        }
                        .cornerRadius(5)
                }
            }
        }
        .font(.system(size: isIpad ? 90 : 60).bold())
        .popover(item: $shareText) { shareText in
            ActivityView(text: shareText.text)
        }
    }
}
