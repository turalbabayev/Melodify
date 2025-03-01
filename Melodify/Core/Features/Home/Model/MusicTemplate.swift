import SwiftUI

struct MusicTemplate: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let category: String
    let gradient: [Color]
    let backgroundColor: Color
    let prompt: String
    let style: String
    let mood: String
    let tempo: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MusicTemplate, rhs: MusicTemplate) -> Bool {
        lhs.id == rhs.id
    }
} 