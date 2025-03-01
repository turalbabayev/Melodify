import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var credits: Int = 0
    @Published var userName: String = "Tural"
    @Published var subscriptionType: SubscriptionType = .premium
    @Published var hoveredTemplate: MusicTemplate?
    @Published var templates: [MusicTemplate] = [
        .init(
            title: "Energetic Pop Hit",
            description: "Upbeat pop song with modern electronic elements",
            icon: "waveform.path.ecg",
            category: "Pop",
            gradient: [AppColors.primaryPurple, AppColors.secondaryBlue],
            backgroundColor: AppColors.primaryPurple.opacity(0.1),
            prompt: "Create an energetic pop song with catchy electronic beats, modern synthesizers, and a dynamic chorus. Include a bridge section with atmospheric elements.",
            style: "Modern Pop",
            mood: "Energetic",
            tempo: "128 BPM"
        ),
        .init(
            title: "Dark Trap Vibes",
            description: "Heavy 808s with atmospheric melodies",
            icon: "speaker.wave.3.fill",
            category: "Hip Hop",
            gradient: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")],
            backgroundColor: Color(hex: "FF6B6B").opacity(0.1),
            prompt: "Generate a dark trap beat with heavy 808 bass, crisp hi-hats, and ethereal pad sounds. Include melodic elements with a mysterious vibe.",
            style: "Trap",
            mood: "Dark",
            tempo: "140 BPM"
        ),
        .init(
            title: "Deep House Journey",
            description: "Progressive house with deep basslines",
            icon: "waveform.path.badge.plus",
            category: "Electronic",
            gradient: [Color(hex: "3AB795"), Color(hex: "86E3BC")],
            backgroundColor: Color(hex: "3AB795").opacity(0.1),
            prompt: "Create a deep house track with rolling basslines, atmospheric pads, and progressive elements. Include breakdown sections with emotional chord progressions.",
            style: "Deep House",
            mood: "Groovy",
            tempo: "124 BPM"
        ),
        .init(
            title: "Chill Study Beats",
            description: "Perfect for focus and relaxation",
            icon: "pianokeys",
            category: "Lo-Fi",
            gradient: [Color(hex: "845EC2"), Color(hex: "B490E6")],
            backgroundColor: Color(hex: "845EC2").opacity(0.1),
            prompt: "Generate a lo-fi hip hop beat with warm vinyl crackles, mellow piano melodies, and soft drum patterns. Include nature sounds and subtle jazz elements.",
            style: "Lo-Fi Hip Hop",
            mood: "Relaxed",
            tempo: "85 BPM"
        )
    ]
    
    private let userService = UserService.shared
    
    init() {
        setupUser()
    }
    
    private func setupUser() {
        userService.initializeUserIfNeeded()
        userService.checkAndUpdateMonthlyCredits()
        updateUserInfo()
    }
    
    private func updateUserInfo() {
        if let user = userService.currentUser {
            credits = user.credits
            subscriptionType = user.subscription
        }
    }
    
    func useCredits(_ amount: Int) -> Bool {
        let success = userService.updateCredits(-amount)
        if success {
            updateUserInfo()
        }
        return success
    }
    
    func addCredits(_ amount: Int) {
        if userService.updateCredits(amount) {
            updateUserInfo()
        }
    }
    
    func selectTemplate(_ template: MusicTemplate) {
        // Şablon seçildiğinde yapılacak işlemler
        print("Seçilen şablon: \(template.title)")
    }
    
        
    // Computed property: Mevcut saate göre selamlama metni üretir
    var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<18:
            return "Good Afternoon"
        case 18..<23:
            return "Good Evening"
        default:
            return "Hello" // Gece 23'ten sonra "Hello" diyebiliriz
        }
    }
    
    // Emoji de dahil etmek istersen bu şekilde:
    var greetingEmoji: String {
        return "👋"
    }
    
    // View’da ikinci satırda kullandığın “Let’s see what can I do for you?”
    // gibi sabit metinleri de buraya koyabilirsin:
    var subHeadline: String {
        return "Let’s see what can I do for you?"
    }
}
