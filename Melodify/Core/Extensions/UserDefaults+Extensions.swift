import Foundation

extension UserDefaults {
    private enum Keys {
        static let credits = "user_credits"
        static let lastCreditUpdate = "last_credit_update"
        static let subscription = "subscription_type"
    }
    
    var credits: Int {
        get { return integer(forKey: Keys.credits) }
        set { set(newValue, forKey: Keys.credits) }
    }
    
    var lastCreditUpdate: Date? {
        get { return object(forKey: Keys.lastCreditUpdate) as? Date }
        set { set(newValue, forKey: Keys.lastCreditUpdate) }
    }
    
    var subscriptionType: SubscriptionType {
        get {
            if let savedValue = string(forKey: Keys.subscription) {
                return SubscriptionType(rawValue: savedValue) ?? .free
            }
            return .free
        }
        set { set(newValue.rawValue, forKey: Keys.subscription) }
    }
    
    // İlk yükleme için kredi verme
    static func setupInitialCredits() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: Keys.credits) == nil {
            defaults.credits = SubscriptionType.free.monthlyCredits
            defaults.subscriptionType = .free
            defaults.lastCreditUpdate = Date()
        }
    }
} 