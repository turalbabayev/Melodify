import Foundation

struct Song: Identifiable {
    let id: String
    let title: String
    let duration: TimeInterval
    let url: URL?
    let imageUrl: URL?
    var isFavorite: Bool
    let lyrics: [LyricLine]?
    let isGenerating: Bool
    let generationStatus: TaskStatus?
    
    init(id: String, title: String, duration: TimeInterval, url: URL?, imageUrl: URL?, isFavorite: Bool, lyrics: [LyricLine]?, isGenerating: Bool, generationStatus: TaskStatus? = nil) {
        self.id = id
        self.title = title
        self.duration = duration
        self.url = url
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
        self.lyrics = lyrics
        self.isGenerating = isGenerating
        self.generationStatus = generationStatus
    }
}

struct LyricLine: Identifiable, Codable {
    let id: UUID
    let text: String
    let timestamp: TimeInterval
} 