import SwiftUI

struct SettingsSection: Identifiable {
    let id = UUID()
    let title: String
    var items: [SettingsItem]
}

enum SettingsItemType {
    case button(() -> Void)
    case toggle(isOn: Binding<Bool>)
    case slider(Double, ClosedRange<Double>)
    case navigation
    case info
    case picker(() -> Void)
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let description: String?
    let type: SettingsItemType
}

