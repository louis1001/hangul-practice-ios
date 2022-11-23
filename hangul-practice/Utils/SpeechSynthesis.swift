//
//  SpeechSynthesis.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import AVFoundation

let synthesizer = AVSpeechSynthesizer()

func playAsAudio(word: String, speed: Double = 1) {
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(.playback, mode: .spokenAudio, options: .mixWithOthers)
    } catch {
        print("Failed to set audio session category")
    }
    
    let utterance = AVSpeechUtterance(string: word)
    utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
    utterance.rate = Float(speed) * AVSpeechUtteranceDefaultSpeechRate
    
    if !synthesizer.isSpeaking {
        synthesizer.speak(utterance)
    }
}
