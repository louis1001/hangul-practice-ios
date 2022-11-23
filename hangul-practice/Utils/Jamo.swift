//
//  Jamo.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 17/11/22.
//

import Foundation
import HangulDisAssemble

// https://www.hackingwithswift.com/example-code/language/how-to-remove-duplicate-items-from-an-array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

class Jamo {
    static let shared = Jamo()
    private init(){}
    
    func decompose(_ word: String) async -> [String]? {
        return Hangul.disassemble(word)
            .removingDuplicates()
    }
}
