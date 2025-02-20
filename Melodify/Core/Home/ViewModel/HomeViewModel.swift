import Foundation

class HomeViewModel: ObservableObject {
    // Ana sayfa için gerekli state ve fonksiyonlar
    @Published var unreadNotifications: Int = 2 // Test için 2 okunmamış bildirim
} 