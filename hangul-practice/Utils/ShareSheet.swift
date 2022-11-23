// Share sheet https://stackoverflow.com/a/72035626

import SwiftUI

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
