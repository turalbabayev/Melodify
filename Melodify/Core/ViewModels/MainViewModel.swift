import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var generatedSongs: [GeneratedMusic] = []
    
    /*
    enum Tab {
        case home, library, create, profile
    }
     */
    
    func navigateToLibrary() {
        selectedTab = .library
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
