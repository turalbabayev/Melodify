import Foundation

struct Song: Identifiable, Codable {
    let id: UUID
    let title: String
    let duration: TimeInterval
    let createdAt: Date
    var isFavorite: Bool
    let lyrics: [LyricLine]?
    
    init(id: UUID = UUID(), title: String, duration: TimeInterval, createdAt: Date = Date(), isFavorite: Bool = false, lyrics: [LyricLine]? = nil) {
        self.id = id
        self.title = title
        self.duration = duration
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.lyrics = lyrics
    }
}

struct LyricLine: Identifiable, Codable {
    let id: UUID
    let text: String
    let timestamp: TimeInterval
} 