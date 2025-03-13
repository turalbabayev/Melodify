import Foundation

class PlaylistManager {
    static let shared = PlaylistManager()
    
    private(set) var playlists: [Playlist] = []
    
    private init() {}
    
    func createPlaylist(name: String) -> Playlist {
        let playlist = Playlist(id: UUID(), name: name, songs: [])
        playlists.append(playlist)
        return playlist
    }
    
    func updatePlaylist(_ updatedPlaylist: Playlist) {
        if let index = playlists.firstIndex(where: { $0.id == updatedPlaylist.id }) {
            playlists[index] = updatedPlaylist
        }
    }
    
    func deletePlaylist(_ playlist: Playlist) {
        playlists.removeAll { $0.id == playlist.id }
    }
    
    func getPlaylist(by id: UUID) -> Playlist? {
        return playlists.first { $0.id == id }
    }
} 
