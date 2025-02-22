import Foundation

enum Tab: String, CaseIterable {
    case home = "Home_Main"
    case search = "Search_Main"
    case create = "Plus_Main"
    case library = "Folder_Main"
    case settings = "Setting_Main"
    
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
