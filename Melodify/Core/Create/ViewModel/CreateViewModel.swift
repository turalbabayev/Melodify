import SwiftUI

class CreateViewModel: ObservableObject {
    @Published var customMode: Bool = false
    @Published var instrumental: Bool = false
    @Published var title: String = ""
    @Published var prompt: String = ""
    @Published var style: String = ""
    
    var isFormValid: Bool {
        if customMode {
            return instrumental ? !style.isEmpty && !title.isEmpty : !style.isEmpty && !prompt.isEmpty && !title.isEmpty
        } else {
            return !prompt.isEmpty
        }
    }
    
    func createMusic() {
        // Müzik oluşturma işlemleri
        print("Creating music with title: \(title), prompt: \(prompt), style: \(style), instrumental: \(instrumental)")
    }
} 