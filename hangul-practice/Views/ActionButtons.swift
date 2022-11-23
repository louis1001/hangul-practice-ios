//
//  ActionButtons.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

struct ActionButtonsSection: View {
    @ObservedObject var container: WordViewModel
    @State private var playSpeed = 1.0
    
    @State private var isIpad = false
    
    var body: some View {
        HStack {
            IpadCheck(isIpad: $isIpad)
            
            VStack {
                Image(systemName: "shuffle")
                Text("random")
            }
            .padding()
            .asButton {
                Task {
                    container.pickRandom()
                }
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "speaker.wave.2.fill")
                Text("play")
            }
            .padding()
            .asButton {
                Task {
                    playAsAudio(word: container.randomWord, speed: playSpeed)
                }
            }
            .contextMenu {
                Label {
                    Text(".2x")
                } icon: {}
                    .asButton {
                        playSpeed = 0.2
                        playAsAudio(word: container.randomWord, speed: playSpeed)
                    }
                
                Label {
                    Text(".5x")
                } icon: {}
                    .asButton {
                        playSpeed = 0.5
                        playAsAudio(word: container.randomWord, speed: playSpeed)
                    }
                
                Label {
                    Text(" 1x")
                } icon: {}
                    .asButton {
                        playSpeed = 1
                        playAsAudio(word: container.randomWord, speed: playSpeed)
                    }
            }
        }
        .font(.system(size: isIpad ? 20 : 18))
    }
}
