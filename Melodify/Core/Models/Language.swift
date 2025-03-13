
import SwiftUI

struct Language: Identifiable, Equatable {
    let id = UUID()
    let name: String      // Dilin görünen adı
    let code: String      // Dil kodu (en, tr, es, fr vs.)
    let flag: String      // Emoji bayrak
    let nativeName: String // Dilin kendi dilindeki adı
    
    static let supportedLanguages: [Language] = [
        Language(name: "English", code: "en", flag: "🇺🇸", nativeName: "English"),
        Language(name: "Türkçe", code: "tr", flag: "🇹🇷", nativeName: "Türkçe"),
        Language(name: "Español", code: "es", flag: "🇪🇸", nativeName: "Español"),
        Language(name: "Français", code: "fr", flag: "🇫🇷", nativeName: "Français"),
        // Yeni diller buraya eklenecek
    ]
} 
