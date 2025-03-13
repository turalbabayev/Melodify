import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var sections: [SettingsSection] = []
    @Published var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "notifications_enabled") {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notifications_enabled")
        }
    }
    @Published var quality: Double = 0.8
    @Published var showConfirmation = false
    @Published var showLanguagePicker = false
    
    let languages = Language.supportedLanguages
    @Published var selectedLanguage: Language
    private let creditManager = CreditStateManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Mevcut dili yükle veya varsayılan olarak English kullan
        if let savedCode = UserDefaults.standard.string(forKey: "app_language"),
           let savedLanguage = Language.supportedLanguages.first(where: { $0.code == savedCode }) {
            self.selectedLanguage = savedLanguage
        } else {
            self.selectedLanguage = Language.supportedLanguages[0] // English
        }
        
        // İlk kurulum
        setupSections()
        
        // Hem kredi hem de subscription değişikliklerini dinle
        Publishers.CombineLatest(
            creditManager.$currentCredits,
            creditManager.$currentSubscription
        )
        .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
        .sink { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.setupSections()
            }
        }
        .store(in: &cancellables)
    }
    
    private func setupSections() {
        self.sections = [
            SettingsSection(title: "Notification".localized, items: [
                SettingsItem(
                    icon: "bell.fill",
                    iconColor: .red,
                    title: "settings_notifications".localized,
                    description: "settings_notifications_description".localized,
                    type: .toggle(isOn: Binding(
                        get: { self.notificationsEnabled },
                        set: { self.notificationsEnabled = $0 }
                    ))
                )
            ]),
            
            SettingsSection(title: "General".localized, items: [
                SettingsItem(
                    icon: "globe",
                    iconColor: .green,
                    title: "settings_language".localized,
                    description: "\(selectedLanguage.flag) \(selectedLanguage.nativeName)",
                    type: .picker { [weak self] in
                        self?.showLanguagePicker = true
                    }
                ),
                SettingsItem(
                    icon: "doc.text.fill",
                    iconColor: .orange,
                    title: "settings_terms".localized,
                    description: nil,
                    type: .navigation
                ),
                SettingsItem(
                    icon: "lock.fill",
                    iconColor: .gray,
                    title: "settings_privacy".localized,
                    description: nil,
                    type: .navigation
                )
            ]),
            
            SettingsSection(title: "Support".localized, items: [
                SettingsItem(
                    icon: "star.fill",
                    iconColor: .yellow,
                    title: "settings_rate_us".localized,
                    description: "settings_rate_us_description".localized,
                    type: .button({ 
                        if let url = URL(string: "itms-apps://apple.com/app/id123456789") {
                            UIApplication.shared.open(url)
                        }
                    })
                ),
                SettingsItem(
                    icon: "envelope.fill",
                    iconColor: .blue,
                    title: "settings_contact".localized,
                    description: "settings_contact_description".localized,
                    type: .button({
                        if let url = URL(string: "mailto:support@melodify.app") {
                            UIApplication.shared.open(url)
                        }
                    })
                ),
                SettingsItem(
                    icon: "square.and.arrow.up",
                    iconColor: .green,
                    title: "settings_share".localized,
                    description: "settings_share_description".localized,
                    type: .button({
                        // Share işlemi burada yapılacak
                    })
                )
            ]),
            
            /*
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
            ]),
            */
            // Data Management section'ını ekle
            SettingsSection(title: "Data Management".localized, items: [
                SettingsItem(
                    icon: "trash",
                    iconColor: .red,
                    title: "settings_clear_data".localized,
                    description: "settings_clear_data_description".localized,
                    type: .button({ [weak self] in
                        self?.showConfirmation = true
                    })
                )
            ]),
            
            SettingsSection(title: "Credits".localized, items: [
                SettingsItem(
                    icon: "creditcard",
                    iconColor: .purple,
                    title: "settings_credits".localized,
                    description: String(format: "settings_credits_description".localized, 
                                      creditManager.currentCredits, 
                                      creditManager.currentSubscription.rawValue),
                    type: .info
                )
            ])
        ]
    }
    
    func clearAllData() {
        CoreDataManager.shared.clearAllData()
        // Bildirimi gönder
        NotificationCenter.default.post(name: .songsDidUpdate, object: nil)
    }
    
    func updateLanguage(_ language: Language) {
        selectedLanguage = language
        
        // Bundle'ı güncelle
        Bundle.setLanguage(language.code)
        
        // UserDefaults'a kaydet
        UserDefaults.standard.set(language.code, forKey: "app_language")
        UserDefaults.standard.synchronize()
        
        // Tüm view'ları yeniden yükle
        DispatchQueue.main.async { [weak self] in
            self?.setupSections()
            NotificationCenter.default.post(name: .languageDidChange, object: nil)
        }
    }
} 
