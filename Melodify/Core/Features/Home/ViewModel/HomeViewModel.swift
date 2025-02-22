import Foundation

class HomeViewModel: ObservableObject {
    @Published var credits: Int = 0
    @Published var subscriptionType: SubscriptionType = .premium
    
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
} 
