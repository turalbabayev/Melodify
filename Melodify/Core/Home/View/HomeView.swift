import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HomeNavigationBar()
            Spacer()
        }
    }
}

// MARK: - Navigation Bar
struct HomeNavigationBar: View {
    var body: some View {
        HStack(spacing: 20) {
            CreditDisplay()
            Spacer()
            NotificationButton()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

// MARK: - Credit Display
struct CreditDisplay: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Credits Available")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.gray)
            
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.yellow)
                    .symbolEffect(.bounce, options: .repeating)
                
                Text("250")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text("AI")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.gray)
                    .padding(.leading, -4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemGray6).opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.15),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
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
            Image(systemName: "bell.badge")
                .font(.system(size: 20, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background {
                    Circle()
                        .fill(Color(UIColor.systemGray6).opacity(0.3))
                        .overlay {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.15),
                                            .clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.5
                                )
                        }
                }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .preferredColorScheme(.dark)
} 
