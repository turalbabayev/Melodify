import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HomeNavigationBar(viewModel: viewModel)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                QuickStartCard()
                    .padding(.horizontal, 16)
            }
        }
        .background(Color.cardBackground)
    }
}

// MARK: - Navigation Bar
struct HomeNavigationBar: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            CreditDisplay(viewModel: viewModel)
            Spacer()
            NotificationButton()
        }
    }
}

// MARK: - Credit Display
struct CreditDisplay: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Credits Available")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.gray)
            
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primaryPurple, .secondaryBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, options: .repeating)
                
                Text("\(viewModel.credits)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                if viewModel.subscriptionType == .premium {
                    Text("PRO")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            LinearGradient(
                                colors: [.primaryPurple, .secondaryBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
        }
    }
}

// MARK: - Notification Button
struct NotificationButton: View {
    var body: some View {
        Button {
            // Bildirimler açılacak
        } label: {
            Image(systemName: "bell")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background {
                    Circle()
                        .fill(Color(UIColor.systemGray6).opacity(0.1))
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        }
                }
        }
    }
}

// MARK: - Quick Start Card
struct QuickStartCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Müzik Üretmeye Başla")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.9)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("AI ile kendi müziğini oluştur")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "waveform")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primaryPurple, .secondaryBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Button {
                // Müzik oluşturma sayfasına git
            } label: {
                HStack {
                    Text("Oluştur")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [.primaryPurple, .secondaryBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .primaryPurple.opacity(0.3),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static let primaryPurple = Color(hex: "8A2BE2") // Parlak mor
    static let secondaryBlue = Color(hex: "4169E1") // Royal mavi
    static let accentColor = Color(hex: "00BFFF")   // Parlak mavi
    static let darkBackground = Color(hex: "0A0A0F") // Koyu arka plan
    static let cardBackground = Color(hex: "1A1A23") // Kart arka planı
}

// MARK: - Preview
#Preview {
    HomeView()
        .preferredColorScheme(.dark)
} 
