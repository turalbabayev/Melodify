import Foundation

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case create = "plus.circle.fill"
    case library = "music.note.list"
    case settings = "gearshape.fill"
    
    var title: String {
        switch self {
        case .home: return "Ana Sayfa"
        case .search: return "Keşfet"
        case .create: return "Oluştur"
        case .library: return "Kitaplık"
        case .settings: return "Ayarlar"
        }
    }
} 