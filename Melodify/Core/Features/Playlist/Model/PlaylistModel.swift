import Foundation

struct Playlist: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String?
    var createdAt: Date
    var songs: [Song]
    
    init(id: UUID = UUID(), name: String, description: String? = nil, songs: [Song] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = Date()
        self.songs = songs
    }
}
