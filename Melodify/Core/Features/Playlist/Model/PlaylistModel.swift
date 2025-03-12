import Foundation

struct Playlist: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String?
    var createdAt: Date
    var songs: [Song]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdAt
        // songs'u encode/decode etmeyeceğiz
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        songs = [] // Başlangıçta boş array
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(createdAt, forKey: .createdAt)
        // songs array'ini encode etmiyoruz
    }
    
    // Manuel init
    init(id: UUID = UUID(), name: String, description: String? = nil, songs: [Song] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = Date()
        self.songs = songs
    }
}
