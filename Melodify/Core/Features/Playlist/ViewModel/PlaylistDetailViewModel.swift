import SwiftUI

class PlaylistDetailViewModel: ObservableObject {
    @Published var playlist: Playlist
    @Published var availableSongs: [Song] = []
    private let playlistManager = PlaylistManager.shared
    
    init(playlist: Playlist) {
        print("📱 PlaylistDetailViewModel init")
        print("   - Playlist: \(playlist.name)")
        print("   - Şarkı sayısı: \(playlist.songs.count)")
        self.playlist = playlist
        loadAvailableSongs()
    }
    
    private func loadAvailableSongs() {
        // CoreData'dan tüm şarkıları yükle
        let allSongs = CoreDataManager.shared.loadSongs()
        
        // Playlist'te olmayan şarkıları filtrele
        let playlistSongIds = Set(playlist.songs.map { $0.id })
        availableSongs = allSongs.filter { !playlistSongIds.contains($0.id) }
        print("🎵 Mevcut şarkılar yüklendi - Toplam: \(availableSongs.count)")
    }
    
    func addSelectedSongs(_ songIds: [String]) {
        print("➕ Şarkılar ekleniyor: \(songIds.count) adet")
        let songsToAdd = availableSongs.filter { songIds.contains($0.id) }
        playlist.songs.append(contentsOf: songsToAdd)
        
        playlistManager.updatePlaylist(playlist)
        
        loadAvailableSongs()
    }
    
    func removeSong(_ song: Song) {
        print("➖ Şarkı siliniyor: \(song.title)")
        playlist.songs.removeAll { $0.id == song.id }
        playlistManager.updatePlaylist(playlist)
        
        loadAvailableSongs()
    }
} 
