//
//  DictionaryReference.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI

class ReferenceAction: ObservableObject {
    var onDefinition: (String)->Void = {_ in }
    func showDefinition(for word: String) {
        onDefinition(word)
    }
    
    func definitionAvailable(for word: String) -> Bool {
        UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word)
    }
}

class ReferenceController: UIViewController {
    func showDefinition(for word: String) {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
            let referenceVC = UIReferenceLibraryViewController(term: word)
            present(referenceVC, animated: true)
        }
    }
}

struct ReferenceRepresentable: UIViewControllerRepresentable {
    var action: ReferenceAction
    func makeUIViewController(context: Context) -> ReferenceController {
        ReferenceController()
    }
    
    func updateUIViewController(_ uiViewController: ReferenceController, context: Context) {
        action.onDefinition = uiViewController.showDefinition
    }
}
