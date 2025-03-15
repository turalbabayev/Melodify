import SwiftUI

class PaywallViewModel: ObservableObject {
    @Published var features: [PremiumFeature] = [
        .init(
            icon: "infinity",
            title: "paywall_feature_unlimited_title",
            description: "paywall_feature_unlimited_desc"
        ),
        .init(
            icon: "wand.and.stars",
            title: "paywall_feature_quality_title",
            description: "paywall_feature_quality_desc"
        ),
        .init(
            icon: "music.note",
            title: "paywall_feature_instrumental_title",
            description: "paywall_feature_instrumental_desc"
        ),
        .init(
            icon: "arrow.down.circle",
            title: "paywall_feature_download_title",
            description: "paywall_feature_download_desc"
        )
    ]
    
    @Published var plans: [SubscriptionPlan] = [
        .init(
            id: "yearly",
            title: "paywall_yearly",
            price: "$39.99",
            pricePerMonth: "$3.33",
            savings: 72,
            isSelected: true
        ),
        .init(
            id: "monthly",
            title: "paywall_monthly",
            price: "$11.99",
            isSelected: false
        )
    ]
    
    func selectPlan(_ selectedPlan: SubscriptionPlan) {
        plans = plans.map { plan in
            var updatedPlan = plan
            updatedPlan.isSelected = plan.id == selectedPlan.id
            return updatedPlan
        }
    }
    
    func purchase() {
        // RevenueCat entegrasyonu burada yapılacak
        if let selectedPlan = plans.first(where: { $0.isSelected }) {
            print("Selected plan: \(selectedPlan.id)")
        }
    }
    
    func showTerms() {
        if let url = URL(string: "https://melodify.app/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    func showPrivacy() {
        if let url = URL(string: "https://melodify.app/privacy") {
            UIApplication.shared.open(url)
        }
    }
} 