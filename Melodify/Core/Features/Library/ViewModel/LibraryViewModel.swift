import Foundation

class LibraryViewModel: ObservableObject {
    @Published var songs: [Song] = []
    @Published var playlists: [Playlist] = []
    @Published var favoriteSongs: [Song] = []
    
    init() {
        loadData()
    }
    
    func toggleFavorite(_ song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            var updatedSong = songs[index]
            updatedSong.isFavorite.toggle()
            songs[index] = updatedSong
            
            // Update favorites list
            if updatedSong.isFavorite {
                favoriteSongs.append(updatedSong)
            } else {
                favoriteSongs.removeAll { $0.id == song.id }
            }
        }
    }
    
    private func loadData() {
        // Dummy data
        songs = [
            Song(
                id: UUID(),
                title: "Aşkın Büyüsü",
                duration: 226,
                isFavorite: true,
                lyrics: [
                    LyricLine(id: UUID(), text: "Gözlerinin içine baktığımda", timestamp: 0),
                    LyricLine(id: UUID(), text: "Kendimi kaybediyorum sanki", timestamp: 15),
                    LyricLine(id: UUID(), text: "Bu aşkın büyüsüne kapıldım", timestamp: 30),
                    LyricLine(id: UUID(), text: "Senden başkasını göremiyorum", timestamp: 45),
                    // ... diğer sözler ...
                ]
            ),
            Song(id: UUID(), title: "Akıl", duration: 171, isFavorite: false),
            Song(id: UUID(), title: "Unsended", duration: 194, isFavorite: true),
            Song(id: UUID(), title: "Empty Chair", duration: 197, isFavorite: false),
            Song(id: UUID(), title: "Kalbimde", duration: 208, isFavorite: true)
        ]
        
        favoriteSongs = songs.filter { $0.isFavorite }
        
        // Load playlists from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "saved_playlists") {
            if let decoded = try? JSONDecoder().decode([Playlist].self, from: data) {
                playlists = decoded
            }
        }
    }
} 