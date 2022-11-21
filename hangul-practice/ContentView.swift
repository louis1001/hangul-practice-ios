//
//  ContentView.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 16/11/22.
//

import SwiftUI
import AVFoundation
import SwiftyTranslate

// Share sheet https://stackoverflow.com/a/72035626
// 1. Activity View
struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

// 2. Share Text
struct ShareText: Identifiable {
    let id = UUID()
    let text: String
}


extension View {
    func asButton(_ action: @escaping()->Void) -> some View {
        Button(action: action, label: { self })
    }
    
    @ViewBuilder
    func applyIf(_ condition: Bool, modification: (Self)->some View) -> some View {
        if condition {
            modification(self)
        } else {
            self
        }
    }
}

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

class Action: ObservableObject {
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
    var action: Action
    func makeUIViewController(context: Context) -> ReferenceController {
        ReferenceController()
    }
    
    func updateUIViewController(_ uiViewController: ReferenceController, context: Context) {
        action.onDefinition = uiViewController.showDefinition
    }
}

struct ContentView: View {
    @StateObject private var container = WordContainer()
    @StateObject private var action = Action()
    
    // 3. Share Text State
    @State var shareText: ShareText?
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    private var isIpad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var backgroundColor: Color {
        Color("BackgroundColor")
    }
    
    @State private var translationDeployed = true
    
    @State private var playSpeed = 1.0
    
    var charactersSection: some View {
        HStack {
            Text("Characters:")
            Spacer()
            HStack{Text(" ")}
                .frame(minWidth: 50, maxWidth: 200)
                .border(.primary)
        }
    }
    
    var dissasembledSection: some View {
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
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(5)
                            .hidden()
                        
                        ForEach(container.decomposition, id: \.self) { char in
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
    
    @ViewBuilder
    var koreanWord: some View {
        Group {
            if container.randomWord.isEmpty {
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
                    
                    Text(container.randomWord)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding()
                        .contextMenu {
                            Label("Copy word", systemImage: "doc.on.doc")
                                .asButton {
                                    UIPasteboard.general.string = container.randomWord
                                }
                            
                            Label("Share", systemImage: "square.and.arrow.up")
                                .asButton {
                                    shareText = ShareText(text: container.randomWord)
                                }
                        }
                        .cornerRadius(5)
                }
            }
        }
        .font(.system(size: isIpad ? 90 : 60).bold())
    }
    
    var actionButtons: some View {
        HStack {
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
    
    var detailsSection: some View {
        VStack(spacing: 40) {
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
                .background(backgroundColor)
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
    }
    
    var body: some View {
        VStack {
            dissasembledSection
                .padding(.top, 30)
                .frame(maxWidth: 900)
            
            VStack(spacing: 20) {
                //            charactersSection
                
                koreanWord
                .padding(.vertical, 50)
                
                VStack(spacing: isIpad ? 30 : 20) {
                    actionButtons
                    
                    detailsSection
                }
                .frame(maxWidth: 600)
            }
            .padding(.horizontal, 35)
            
            Spacer()
        }
        .padding(.vertical)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(backgroundColor.ignoresSafeArea())
        .overlay(
            ReferenceRepresentable(action: action)
            .allowsHitTesting(false)
        )
        .popover(item: $shareText) { shareText in
            ActivityView(text: shareText.text)
        }
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
