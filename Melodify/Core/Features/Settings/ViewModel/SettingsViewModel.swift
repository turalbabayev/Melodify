import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var sections: [SettingsSection]
    @Published var notificationsEnabled: Bool = true
    @Published var quality: Double = 0.8
    @Published var selectedLanguage: Int = 0 {
        didSet {
            updateLanguageDescription()
        }
    }
    
    private let languages = ["English", "Türkçe"]
    
    init() {
        self.sections = []
        setupSections()
    }
    
    private func setupSections() {
        self.sections = [
            SettingsSection(title: "Audio", items: [
                SettingsItem(
                    icon: "waveform",
                    iconColor: .blue,
                    title: "Quality",
                    description: "Adjust audio quality",
                    type: .slider(0.8, 0.0...1.0)
                ),
                SettingsItem(
                    icon: "bell.fill",
                    iconColor: .red,
                    title: "Notifications",
                    description: "Enable push notifications",
                    type: .toggle(true)
                )
            ]),
            
            SettingsSection(title: "General", items: [
                SettingsItem(
                    icon: "globe",
                    iconColor: .green,
                    title: "Language",
                    description: languages[selectedLanguage],
                    type: .navigation
                ),
                SettingsItem(
                    icon: "doc.text.fill",
                    iconColor: .orange,
                    title: "Terms of Service",
                    description: nil,
                    type: .navigation
                ),
                SettingsItem(
                    icon: "lock.fill",
                    iconColor: .gray,
                    title: "Privacy Policy",
                    description: nil,
                    type: .navigation
                )
            ]),
            
            SettingsSection(title: "Support", items: [
                SettingsItem(
                    icon: "star.fill",
                    iconColor: .yellow,
                    title: "Rate Us",
                    description: "Love using Melodify? Let us know!",
                    type: .button({ 
                        if let url = URL(string: "itms-apps://apple.com/app/id123456789") {
                            UIApplication.shared.open(url)
                        }
                    })
                ),
                SettingsItem(
                    icon: "envelope.fill",
                    iconColor: .blue,
                    title: "Contact Us",
                    description: "Have questions or feedback?",
                    type: .button({
                        if let url = URL(string: "mailto:support@melodify.app") {
                            UIApplication.shared.open(url)
                        }
                    })
                ),
                SettingsItem(
                    icon: "square.and.arrow.up",
                    iconColor: .green,
                    title: "Share App",
                    description: "Share Melodify with friends",
                    type: .button({
                        // Share işlemi burada yapılacak
                    })
                )
            ]),
            
            SettingsSection(title: "Account", items: [
                SettingsItem(
                    icon: "person.fill",
                    iconColor: .blue,
                    title: "Profile",
                    description: "View and edit your profile",
                    type: .navigation
                ),
                SettingsItem(
                    icon: "arrow.right.square.fill",
                    iconColor: .red,
                    title: "Sign Out",
                    description: nil,
                    type: .button({ print("Sign out tapped") })
                )
            ])
        ]
    }
    
    private func updateLanguageDescription() {
        // Sections içindeki Language item'ını bul ve güncelle
        if let sectionIndex = sections.firstIndex(where: { section in
            section.items.contains(where: { $0.title == "Language" })
        }) {
            // Önce mevcut section'ı al
            var updatedSection = sections[sectionIndex]
            
            // Section içindeki language item'ını bul
            if let itemIndex = updatedSection.items.firstIndex(where: { $0.title == "Language" }) {
                // Yeni item oluştur
                let updatedItem = SettingsItem(
                    icon: "globe",
                    iconColor: .green,
                    title: "Language",
                    description: languages[selectedLanguage],
                    type: .navigation
                )
                
                // Section'ın items array'ini güncelle
                updatedSection.items[itemIndex] = updatedItem
                
                // Ana sections array'ini güncelle
                sections[sectionIndex] = updatedSection
            }
        }
    }
} 