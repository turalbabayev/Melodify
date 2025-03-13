import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                mainContent
            }
            .navigationTitle("settings".localized)
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.showLanguagePicker) {
                LanguagePickerView(viewModel: viewModel)
                    .presentationDetents([.height(250)])
            }
            .alert("Clear All Data", isPresented: $viewModel.showConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    viewModel.clearAllData()
                }
            } message: {
                Text("Are you sure you want to clear all your data? This action cannot be undone.")
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.black,
                Color.purple.opacity(0.3),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var mainContent: some View {
        List {
            settingsSections
            appInfoSection
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
    }
    
    private var settingsSections: some View {
        ForEach(viewModel.sections) { section in
            Section(header: sectionHeader(title: section.title)) {
                ForEach(section.items) { item in
                    SettingsItemView(item: item)
                        .listRowBackground(Color.black.opacity(0.1))
                }
            }
        }
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .foregroundColor(.gray)
            .font(.system(size: 14, weight: .semibold))
            .textCase(nil)
    }
    
    private var appInfoSection: some View {
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
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
} 
