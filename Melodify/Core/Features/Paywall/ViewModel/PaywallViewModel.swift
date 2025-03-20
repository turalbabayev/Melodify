import SwiftUI

class PaywallViewModel: ObservableObject {
    @Published var features: [PremiumFeature] = []
    @Published var plans: [SubscriptionPlan] = [
        .init(
            id: "yearly",
            title: "paywall_yearly",
            price: "$79.99",
            pricePerMonth: "$6.67",
            credits: 3500,
            savings: 50,
            isSelected: true
        ),
        .init(
            id: "weekly",
            title: "paywall_weekly",
            price: "$7.99",
            credits: 250,
            isSelected: false
        )
    ]
    
    let audioPlayer = PaywallAudioPlayer.shared
    
    init() {
        // İlk yüklemede varsayılan plan (yıllık) için feature'ları ayarla
        updateFeatures(for: plans[0])
        //playBackgroundMusic()
    }
    
    private func playBackgroundMusic() {
        if let musicUrl = Bundle.main.url(forResource: "sample-music", withExtension: "mp3") {
            audioPlayer.setupPlayer(with: musicUrl)
            audioPlayer.play()
        }
    }
    
    deinit {
        // View kapandığında müziği durdur
        audioPlayer.stop()
    }
    
    func selectPlan(_ selectedPlan: SubscriptionPlan) {
        plans = plans.map { plan in
            var updatedPlan = plan
            updatedPlan.isSelected = plan.id == selectedPlan.id
            return updatedPlan
        }
        
        // Seçilen plana göre feature'ları güncelle
        updateFeatures(for: selectedPlan)
    }
    
    private func updateFeatures(for plan: SubscriptionPlan) {
        let isYearly = plan.id == "yearly"
        
        features = [
            .init(
                icon: "music.note.list",
                title: "paywall_feature_credits_title",
                description: isYearly ? 
                    "paywall_feature_credits_yearly".localized :
                    "paywall_feature_credits_weekly".localized
            ),
            .init(
                icon: "wand.and.stars",
                title: "paywall_feature_quality_title",
                description: isYearly ?
                    "paywall_feature_quality_yearly".localized :
                    "paywall_feature_quality_weekly".localized
            ),
            .init(
                icon: "bolt.shield",
                title: "paywall_feature_priority_title",
                description: isYearly ?
                    "paywall_feature_priority_yearly".localized :
                    "paywall_feature_priority_weekly".localized
            )
        ]
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
    
    func restorePurchases() {
        // RevenueCat entegrasyonu yapıldığında burada restore işlemi yapılacak
        print("Restore purchases tapped")
    }
} 
