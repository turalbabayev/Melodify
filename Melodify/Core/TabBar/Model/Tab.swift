import Foundation

enum Tab: String, CaseIterable {
    case home = "Home_Main"
    case search = "Search_Main"
    case create = "Plus_Main"
    case library = "Folder_Main"
    case settings = "Setting_Main"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Explore"
        case .create: return "Create"
        case .library: return "Library"
        case .settings: return "Settings"
        }
    }
} 
