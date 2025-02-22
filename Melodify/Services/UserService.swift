import Foundation

final class UserService {
    static let shared = UserService()
    private let defaults = UserDefaults.standard
    
    private let userKey = "current_user"
    
    private init() {}
    
    var currentUser: User? {
        get {
            guard let data = defaults.data(forKey: userKey) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            defaults.set(data, forKey: userKey)
        }
    }
    
    func initializeUserIfNeeded() {
        if currentUser == nil {
            currentUser = User()
        }
    }
    
    func updateCredits(_ amount: Int) -> Bool {
        guard var user = currentUser else { return false }
        
        if user.credits + amount >= 0 {
            user.credits += amount
            currentUser = user
            return true
        }
        return false
    }
    
    func checkAndUpdateMonthlyCredits() {
        guard var user = currentUser else { return }
        
        let calendar = Calendar.current
        if let lastUpdate = calendar.date(byAdding: .month, value: 1, to: user.lastCreditUpdate),
           lastUpdate < Date() {
            user.credits += user.subscription.monthlyCredits
            user.lastCreditUpdate = Date()
            currentUser = user
        }
    }
} 