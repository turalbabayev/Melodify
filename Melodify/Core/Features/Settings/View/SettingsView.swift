import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sections) { section in
                    Section(header: SettingsSectionHeader(title: section.title)) {
                        ForEach(section.items) { item in
                            if item.title == "Language" {
                                NavigationLink(destination: LanguageView(viewModel: viewModel)) {
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
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                SettingsRow(item: item)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .background(Color.black.opacity(0.9))
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60) // TabBar için extra padding
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
} 