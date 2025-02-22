import Foundation

struct User: Codable {
    let id: String
    var credits: Int
    var subscription: SubscriptionType
    var lastCreditUpdate: Date
    
    init(id: String = UUID().uuidString) {
        self.id = id
        self.credits = 2500 // Premium başlangıç kredisi
        self.subscription = .premium // Varsayılan olarak premium
        self.lastCreditUpdate = Date()
    }
}

enum SubscriptionType: String, Codable {
    case free
    case premium
    
    var monthlyCredits: Int {
        switch self {
        case .free: return 100
        case .premium: return 2500
        }
    }
} 