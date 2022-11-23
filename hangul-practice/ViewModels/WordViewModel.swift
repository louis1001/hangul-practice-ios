//
//  WordViewModel.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 18/11/22.
//

import SwiftUI
import SwiftyTranslate

class WordViewModel: ObservableObject {
    @Published private(set) var words: [String]! = nil
    
    @Published private(set) var randomWord = ""
    
    @Published private(set) var decomposition: [String] = []
    
    init() {

    }
    
    @Published var translation: String = ""

    func fetchWords() throws {
        guard let path = Bundle.main.url(forResource: "kodict_entry", withExtension: "txt") else {
            return
        }
        
        let contents = try String(contentsOf: path)

        var words = contents.components(separatedBy: "\n")
            .filter { !$0.localizedCaseInsensitiveContains("_") }
        words.removeFirst()
        
        self.words = words
        self.pickRandom()
    }
    
    func getTranslation(for word: String) async {
        do {
            
            let result = try await SwiftyTranslate.translate(text: word, from: "ko", to: "en")
            
            guard word == randomWord else {
                return
            }

            await MainActor.run {
                translation = result.translated
            }
        } catch let e {
            print("TranslationError: ", e.localizedDescription)
        }
    }
    
    func pickRandom() {
        DispatchQueue.main.async {
            self.translation = ""
            self.decomposition = []
        }
        guard words != nil else {
            randomWord = ""
            return
        }
        let random = Int.random(in: 0..<words.count)
        
        let pickedWord = self.words[random]
        
        Task {
            let decomposed = await Jamo.shared.decompose(pickedWord) ?? []
            
            await MainActor.run {
                self.decomposition = decomposed
                self.randomWord = pickedWord
            }
            
            await getTranslation(for: pickedWord)
        }
    }
}
