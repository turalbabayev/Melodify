import Foundation
import Combine

class UserService {
    static let shared = UserService()
    private let creditManager = CreditManager.shared
    
    @Published var currentUser: User?
    
    private init() {
        // İlk kullanıcı oluşturma
        currentUser = User(
            id: UUID().uuidString,
            name: "Tural",
            credits: creditManager.currentCredits,
            subscription: UserDefaults.standard.subscriptionType
        )
    }
    
    func initializeUserIfNeeded() {
        // Kredi sistemini senkronize et
        if let user = currentUser {
            creditManager.syncCredits(user.credits)
        } else {
            // Yeni kullanıcı oluştur
            currentUser = User(
                id: UUID().uuidString,
                name: "Tural",
                credits: creditManager.currentCredits,
                subscription: UserDefaults.standard.subscriptionType
            )
        }
    }
    
    func updateCredits(_ amount: Int) -> Bool {
        if amount < 0 {
            guard creditManager.hasEnoughCredits() else { return false }
            creditManager.useCredit()
            print("💳 Credit used. New balance: \(creditManager.currentCredits)")
        } else {
            creditManager.addCredits(amount)
            print("💳 Credits added. New balance: \(creditManager.currentCredits)")
        }
        
        if var user = currentUser {
            user.credits = creditManager.currentCredits
            currentUser = user
        }
        
        NotificationCenter.default.post(name: .creditsDidUpdate, object: nil)
        return true
    }
    
    func checkAndUpdateMonthlyCredits() {
        guard let user = currentUser,
              let lastUpdate = UserDefaults.standard.lastCreditUpdate else {
            return
        }
        
        // Son güncellemenin üzerinden bir ay geçmiş mi kontrol et
        let calendar = Calendar.current
        if let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: Date()),
           lastUpdate < oneMonthAgo {
            // Aylık kredileri ekle
            let monthlyCredits = user.subscription.monthlyCredits
            creditManager.addCredits(monthlyCredits)
            
            // Son güncelleme tarihini güncelle
            UserDefaults.standard.lastCreditUpdate = Date()
            
            print("🎉 Monthly credits (\(monthlyCredits)) added!")
        }
    }
    
    func updateSubscription(_ type: SubscriptionType) {
        if var user = currentUser {
            user.subscription = type
            currentUser = user
            
            // Subscription'ı UserDefaults'a kaydet
            UserDefaults.standard.subscriptionType = type
            
            // Aylık kredileri ekle
            let monthlyCredits = type.monthlyCredits
            creditManager.syncCredits(monthlyCredits)
            
            // User modelini güncelle
            user.credits = monthlyCredits
            currentUser = user
            
            // Son güncelleme tarihini kaydet
            UserDefaults.standard.lastCreditUpdate = Date()
            
            // Kredi güncellemesi bildirimini gönder
            NotificationCenter.default.post(name: .creditsDidUpdate, object: nil)
            
            print("🔄 Subscription updated to: \(type)")
            print("💳 Credits reset to: \(monthlyCredits)")
        }
    }
} 
