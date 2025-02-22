import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, animation: animation)
            }
        }
        .padding(.top, 15)
        .background {
            ZStack {
                // Ana arka plan
                Rectangle()
                    .fill(Color.cardBackground)
                    .shadow(color: .black.opacity(0.15), radius: 20, y: -5) // Yukarı doğru hafif gölge
                
                // Üst kısımda hafif gradient
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.primaryPurple.opacity(0.05),
                                Color.secondaryBlue.opacity(0.03),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Üst çizgi
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.primaryPurple.opacity(0.2),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 0.5)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .blur(radius: 0.5)
            }
            .overlay(
                // Üst kısımda extra blur efekti
                Rectangle()
                    .fill(.ultraThinMaterial.opacity(0.5))
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .top)
            )
            .ignoresSafeArea()
        }
    }
} 