import SwiftUI

struct SettingsSection: Identifiable {
    let id = UUID()
    let title: String
    var items: [SettingsItem]
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let icon: String // SF Symbols icon name
    let iconColor: Color
    let title: String
    let description: String?
    let type: SettingsItemType
}

enum SettingsItemType {
    case toggle(Bool)
    case navigation
    case button(() -> Void)
    case slider(Double, ClosedRange<Double>)
    case picker([String], Int)
} 