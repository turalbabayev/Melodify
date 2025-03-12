import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var songs: [Song] = []
    private var mainViewModel: MainViewModel
    private var cancellable: AnyCancellable?
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        
        // Önce Core Data'dan şarkıları yükle
        loadSavedSongs()
        
        // Sonra yeni şarkıları dinle
        cancellable = mainViewModel.$generatedSongs
            .sink { [weak self] songs in
                self?.handleNewSongs(songs)
            }
    }
    
    private func loadSavedSongs() {
        let savedSongs = CoreDataManager.shared.loadSongs()
        DispatchQueue.main.async {
            self.songs = savedSongs
            print("Loaded \(savedSongs.count) songs from Core Data")
        }
    }
    
    private func handleNewSongs(_ generatedSongs: [GeneratedMusic]) {
        // Sadece SUCCESS durumundaki şarkıları kaydet
        for song in generatedSongs {
            if song.status == .SUCCESS {
                CoreDataManager.shared.saveSong(song)
            }
        }
        
        // Tüm şarkıları göster
        let allSongs = generatedSongs.map(convertToSong)
        
        DispatchQueue.main.async {
            // Mevcut şarkıları koruyarak yeni şarkıları ekle
            let existingIds = Set(self.songs.map { $0.id })
            let newSongs = allSongs.filter { !existingIds.contains($0.id) }
            self.songs.append(contentsOf: newSongs)
        }
    }
    
    // GeneratedMusic'i Song modeline dönüştür
    private func convertToSong(_ generatedMusic: GeneratedMusic) -> Song {
        return Song(
            id: generatedMusic.id,
            title: generatedMusic.title,
            duration: generatedMusic.duration ?? 0,
            url: URL(string: generatedMusic.streamAudioUrl),
            imageUrl: URL(string: generatedMusic.imageUrl),
            isFavorite: false,
            lyrics: [],
            isGenerating: generatedMusic.status != .SUCCESS,
            generationStatus: generatedMusic.status
        )
    }
    
    func toggleFavorite(_ song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            var updatedSong = songs[index]
            updatedSong.isFavorite.toggle()
            songs[index] = updatedSong
            
            // Core Data'yı güncelle
            CoreDataManager.shared.updateSongFavorite(id: song.id, isFavorite: updatedSong.isFavorite)
            
            // Favorites listesini güncelle
            if updatedSong.isFavorite {
                favoriteSongs.append(updatedSong)
            } else {
                favoriteSongs.removeAll { $0.id == song.id }
            }
        }
    }
    
    @Published var playlists: [Playlist] = []
    @Published var favoriteSongs: [Song] = []
    
    // Playlists'i yükle
    private func loadInitialData() {
        if let data = UserDefaults.standard.data(forKey: "saved_playlists") {
            if let decoded = try? JSONDecoder().decode([Playlist].self, from: data) {
                playlists = decoded
            }
        }
    }
} 