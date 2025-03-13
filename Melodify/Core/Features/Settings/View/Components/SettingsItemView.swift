import SwiftUI

struct SettingsItemView: View {
    let item: SettingsItem
    
    var body: some View {
        switch item.type {
        case .button(let action):
            Button(action: action) {
                settingsRow
            }
            .foregroundColor(.primary)
            
        case .toggle(let isOn):
            Toggle(isOn: isOn) {
                settingsRow
            }
            .tint(.purple)
            
        case .slider(let value, let range):
            HStack {
                settingsRow
                Slider(value: .constant(value), in: range)
                    .frame(width: 100)
            }
            
        case .navigation:
            NavigationLink {
                Text(item.title)
            } label: {
                settingsRow
            }
            .foregroundColor(.primary)
            
        case .info:
            settingsRow
            
        case .picker(let action):
            Button(action: action) {
                HStack {
                    settingsRow
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
            .foregroundColor(.primary)
        }
    }
    
    private var settingsRow: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: item.icon)
                .foregroundColor(item.iconColor)
                .font(.system(size: 20))
                .frame(width: 30)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                if let description = item.description {
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
    }
} 