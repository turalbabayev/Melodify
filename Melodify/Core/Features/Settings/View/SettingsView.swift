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
                                .listRowBackground(Color.black.opacity(0.2))
                            } else {
                                SettingsRow(item: item)
                                    .listRowBackground(Color.black.opacity(0.2))
                            }
                        }
                    }
                }
                
                // App Info Section
                Section {
                    VStack(spacing: 4) {
                        Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Developed by Tural Babayev")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .background(AppColors.cardBackground)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
} 
