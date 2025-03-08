import Foundation
import SwiftUI

class PlaylistViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var showingCreateSheet = false
    @Published var newPlaylistName = ""
    @Published var newPlaylistDescription = ""
    @Published var featuredPlaylistId: UUID?
    
    private let playlistsKey = "saved_playlists"
    private let featuredPlaylistKey = "featured_playlist_id"
    
    init() {
        loadPlaylists()
        loadFeaturedPlaylistId()
    }
    
    func loadPlaylists() {
        if let data = UserDefaults.standard.data(forKey: playlistsKey) {
            if let decoded = try? JSONDecoder().decode([Playlist].self, from: data) {
                playlists = decoded
            }
        }
    }
    
    private func savePlaylists() {
        if let encoded = try? JSONEncoder().encode(playlists) {
            UserDefaults.standard.set(encoded, forKey: playlistsKey)
        }
    }
    
    func createPlaylist() {
        guard !newPlaylistName.isEmpty else { return }
        
        let playlist = Playlist(
            name: newPlaylistName,
            description: newPlaylistDescription.isEmpty ? nil : newPlaylistDescription
        )
        
        playlists.append(playlist)
        savePlaylists()
        
        newPlaylistName = ""
        newPlaylistDescription = ""
        showingCreateSheet = false
    }
    
    func deletePlaylist(_ playlist: Playlist) {
        playlists.removeAll { $0.id == playlist.id }
        savePlaylists()
    }
    
    var featuredPlaylist: Playlist? {
        if let id = featuredPlaylistId {
            return playlists.first { $0.id == id }
        }
        return playlists.first
    }
    
    func setFeaturedPlaylist(_ playlist: Playlist) {
        featuredPlaylistId = playlist.id
        UserDefaults.standard.set(playlist.id.uuidString, forKey: featuredPlaylistKey)
    }
    
    private func loadFeaturedPlaylistId() {
        if let idString = UserDefaults.standard.string(forKey: featuredPlaylistKey),
           let id = UUID(uuidString: idString) {
            featuredPlaylistId = id
        }
    }
} 