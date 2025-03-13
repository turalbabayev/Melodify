import Foundation

struct User {
    let id: String
    var name: String
    var credits: Int
    var subscription: SubscriptionType
    var lastCreditUpdate: Date
    
    init(
        id: String,
        name: String,
        credits: Int,
        subscription: SubscriptionType,
        lastCreditUpdate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.credits = credits
        self.subscription = subscription
        self.lastCreditUpdate = lastCreditUpdate
    }
}

enum SubscriptionType: String, Codable {
    case free
    case premium
    case pro
    
    var monthlyCredits: Int {
        switch self {
        case .free: return 100
        case .premium: return 2500
        case .pro: return 5000
        }
    }
} 