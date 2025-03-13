import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var songs: [Song] = []
    private var mainViewModel: MainViewModel
    private var cancellable: AnyCancellable?
    private let coreDataManager = CoreDataManager.shared
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        
        // Önce Core Data'dan şarkıları yükle
        loadSavedSongs()
        
        // Sonra yeni şarkıları dinle
        cancellable = mainViewModel.$generatedSongs
            .sink { [weak self] songs in
                self?.handleNewSongs(songs)
            }
        
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSongsUpdate),
            name: .songsDidUpdate,
            object: nil
        )
    }
    
    @objc private func handleSongsUpdate() {
        loadSongs()
    }
    
    private func loadSongs() {
        songs = coreDataManager.loadSongs()
    }
    
    private func loadSavedSongs() {
        let savedSongs = CoreDataManager.shared.loadSongs()
        DispatchQueue.main.async {
            self.songs = savedSongs
            print("Loaded \(savedSongs.count) songs from Core Data")
        }
    }
    
    private func handleNewSongs(_ generatedSongs: [GeneratedMusic]) {
        DispatchQueue.main.async {
            // 1. Önce mevcut generating durumundaki geçici rowları kaldır
            self.songs.removeAll { $0.isGenerating }
            
            // 2. Yeni gelen şarkıları dönüştür
            let newSongs = generatedSongs.map { generatedMusic -> Song in
                // Eğer şarkı başarıyla üretildiyse kaydet
                if generatedMusic.status == .SUCCESS {
                    CoreDataManager.shared.saveSong(generatedMusic)
                }
                
                return self.convertToSong(generatedMusic)
            }
            
            // 3. Yeni şarkıları ekle (duplicate'leri önle)
            let existingIds = Set(self.songs.map { $0.id })
            let uniqueNewSongs = newSongs.filter { !existingIds.contains($0.id) }
            self.songs.append(contentsOf: uniqueNewSongs)
        }
    }
    
    private func convertToSong(_ generatedMusic: GeneratedMusic) -> Song {
        return Song(
            id: generatedMusic.id,
            title: generatedMusic.title,
            duration: generatedMusic.duration ?? 0,
            url: URL(string: generatedMusic.audioUrl),
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
} 