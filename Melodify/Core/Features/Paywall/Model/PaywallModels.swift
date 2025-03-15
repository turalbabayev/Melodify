import Foundation

struct PremiumFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct SubscriptionPlan: Identifiable {
    let id: String
    let title: String
    let price: String
    var pricePerMonth: String? = nil
    var savings: Int? = nil
    var isSelected: Bool
} 