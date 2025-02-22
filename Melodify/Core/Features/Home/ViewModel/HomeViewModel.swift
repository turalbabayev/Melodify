import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var credits: Int = 0
    @Published var subscriptionType: SubscriptionType = .premium
    @Published var hoveredTemplate: MusicTemplate?
    @Published var templates: [MusicTemplate] = [
        .init(
            title: "Modern Pop",
            description: "AI-generated modern pop style",
            icon: "waveform.path.ecg",
            category: "Pop",
            gradient: [AppColors.primaryPurple, AppColors.secondaryBlue],
            backgroundColor: AppColors.primaryPurple.opacity(0.1)
        ),
        .init(
            title: "Trap Beat",
            description: "Modern trap style with powerful rhythms",
            icon: "speaker.wave.3.fill",
            category: "Hip Hop",
            gradient: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")],
            backgroundColor: Color(hex: "FF6B6B").opacity(0.1)
        ),
        .init(
            title: "Deep House",
            description: "Deep bass and atmospheric sounds",
            icon: "waveform.path.badge.plus",
            category: "Electronic",
            gradient: [Color(hex: "3AB795"), Color(hex: "86E3BC")],
            backgroundColor: Color(hex: "3AB795").opacity(0.1)
        ),
        .init(
            title: "Lo-Fi",
            description: "Relaxing lo-fi style music",
            icon: "pianokeys",
            category: "Ambient",
            gradient: [Color(hex: "845EC2"), Color(hex: "B490E6")],
            backgroundColor: Color(hex: "845EC2").opacity(0.1)
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
} 
