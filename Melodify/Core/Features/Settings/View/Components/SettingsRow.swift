import SwiftUI

struct SettingsRow: View {
    let item: SettingsItem
    @State private var isOn: Bool = false
    @State private var sliderValue: Double = 0.5
    @State private var selectedIndex: Int = 0
    
    var body: some View {
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
                    .foregroundColor(.white)
                
                if let description = item.description {
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Control
            switch item.type {
            case .toggle(let isEnabled):
                Toggle("", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    .onAppear { isOn = isEnabled }
                
            case .navigation:
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .semibold))
                
            case .button:
                EmptyView()
                
            case .slider(let value, let range):
                Slider(value: $sliderValue, in: range)
                    .accentColor(.purple)
                    .frame(width: 100)
                    .onAppear { sliderValue = value }
                
            case .picker(let options, let index):
                Picker("", selection: $selectedIndex) {
                    ForEach(0..<options.count, id: \.self) { i in
                        Text(options[i]).tag(i)
                    }
                }
                .pickerStyle(.menu)
                .onAppear { selectedIndex = index }
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            if case .button(let action) = item.type {
                action()
            }
        }
    }
} 
