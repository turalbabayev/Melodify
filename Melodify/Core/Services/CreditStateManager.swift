import Foundation
import Combine

class CreditStateManager: ObservableObject {
    static let shared = CreditStateManager()
    
    @Published var currentCredits: Int = 0
    @Published var currentSubscription: SubscriptionType = .free
    
    private let userService = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // UserService'den değişiklikleri dinle
        userService.$currentUser
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.currentCredits = user.credits
                self?.currentSubscription = user.subscription
            }
            .store(in: &cancellables)
    }
    
    // Kredi durumunu güncelle
    func updateCredits(_ amount: Int) {
        userService.updateCredits(amount)
    }
    
    // Subscription'ı güncelle
    func updateSubscription(_ type: SubscriptionType) {
        userService.updateSubscription(type)
    }
} 