import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedTab: Tab = .home {
        didSet {
            // Tab değiştiğinde state'i sıfırla
            if selectedTab != .create {
                musicGeneratorViewModel?.resetState()
                pendingPrompt = nil
                // Dismiss notification'ı gönder
                NotificationCenter.default.post(
                    name: NSNotification.Name("DismissDetailView"),
                    object: nil
                )
            }
        }
    }
    @Published var generatedSongs: [GeneratedMusic] = []
    @Published var musicGeneratorViewModel: MusicGeneratorViewModel?
    private var pendingPrompt: MusicPromptTemplate?  // Bekleyen prompt'u tut
    
    /*
    enum Tab {
        case home, library, create, profile
    }
     */
    
    
    func navigateToLibrary() {
        selectedTab = .library
    }
    
    func navigateToCreate() {
        selectedTab = .create
    }
    
    func navigateToCreateWithPrompt(_ prompt: MusicPromptTemplate) {
        selectedTab = .create
        
        if let viewModel = musicGeneratorViewModel {
            viewModel.updateWithPrompt(prompt)
            print("✅ Prompt iletildi")
        } else {
            // ViewModel henüz hazır değil, prompt'u sakla
            pendingPrompt = prompt
            print("⏳ Prompt beklemede")
        }
    }
    
    // MusicGeneratorViewModel'i set etmek için
    func setMusicGeneratorViewModel(_ viewModel: MusicGeneratorViewModel) {
        self.musicGeneratorViewModel = viewModel
        print("🔄 MusicGeneratorViewModel set edildi")
        
        // Bekleyen prompt varsa şimdi işle
        if let prompt = pendingPrompt {
            viewModel.updateWithPrompt(prompt)
            pendingPrompt = nil
            print("✅ Bekleyen prompt işlendi")
        }
    }
    
    func addGeneratedSongs(_ songs: [GeneratedMusic]) {
        generatedSongs = songs + generatedSongs
    }
    
    func updateGeneratedSong(_ updatedSong: GeneratedMusic) {
        if let index = generatedSongs.firstIndex(where: { $0.id == updatedSong.id }) {
            generatedSongs[index] = updatedSong
        }
    }
} 
