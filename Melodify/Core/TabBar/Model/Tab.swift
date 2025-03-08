import Foundation

enum Tab: String, CaseIterable {
    case home = "Home_Main"
    case playlist = "playlist"
    case create = "Plus_Main"
    case library = "Folder_Main"
    case settings = "Setting_Main"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .playlist: return "Playlist"
        case .create: return "Create"
        case .library: return "Library"
        case .settings: return "Settings"
        }
    }
} 
