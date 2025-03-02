import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var credits: Int = 0
    @Published var userName: String = "Tural"
    @Published var subscriptionType: SubscriptionType = .premium
    
    // Yeni şablon verileri
    @Published var templates: [TemplateCardModel] = [
        .init(imageName: "template1", category: "Pop", title: "Funky Beat", styleDescription: "Groovy style"),
        .init(imageName: "template2", category: "Electronic", title: "Chill Vibes", styleDescription: "Relaxing beats"),
        .init(imageName: "template3", category: "Hip Hop", title: "Trap Anthem", styleDescription: "Heavy bass"),
        .init(imageName: "template4", category: "Jazz", title: "Smooth Jazz", styleDescription: "Calm melodies"),
        .init(imageName: "template4", category: "Rock", title: "Classic Rock", styleDescription: "Timeless hits"),
        .init(imageName: "template2", category: "Reggae", title: "Island Vibes", styleDescription: "Feel the rhythm"),
        .init(imageName: "template3", category: "R&B", title: "Soulful Sounds", styleDescription: "Emotional tunes"),
        .init(imageName: "template1", category: "Indie", title: "Indie Pop", styleDescription: "Fresh sounds")
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
    
    // View'da ikinci satırda kullandığın "Let's see what can I do for you?"
    // gibi sabit metinleri de buraya koyabilirsin:
    var subHeadline: String {
        return "Let's see what can I do for you?"
    }
}
