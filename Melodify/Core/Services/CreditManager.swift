import Foundation

class CreditManager {
    static let shared = CreditManager()
    
    private init() {}
    
    var currentCredits: Int {
        UserDefaults.standard.credits
    }
    
    func hasEnoughCredits() -> Bool {
        return currentCredits > 0
    }
    
    func useCredit() {
        if hasEnoughCredits() {
            UserDefaults.standard.credits -= 1
        }
    }
    
    func addCredits(_ amount: Int) {
        UserDefaults.standard.credits += amount
    }
    
    func syncCredits(_ amount: Int) {
        UserDefaults.standard.credits = amount
    }
} 