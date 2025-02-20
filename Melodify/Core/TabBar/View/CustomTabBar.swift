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
                    .fill(.black)
                    .opacity(0.85)
                
                // Hafif gradient efekti
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.red.opacity(0.08),
                                Color.red.opacity(0.05),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Çok ince üst çizgi
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .red.opacity(0.2),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 0.2)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .blur(radius: 0.2)
            }
            .ignoresSafeArea()
        }
    }
} 