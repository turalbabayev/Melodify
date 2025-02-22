import SwiftUI

struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if tab == .create {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                Image(tab.rawValue)
                    .renderingMode(.template)
                    .font(tab == .create ? .title2.bold() : .body)
                    .symbolEffect(.bounce, value: selectedTab == tab)
                    .foregroundStyle(getIconColor(for: tab))
                    .frame(width: tab == .create ? 56 : 30, height: tab == .create ? 56 : 30)
                    .background {
                        if selectedTab == tab && tab != .create {
                            Circle()
                                .fill(AppColors.primaryPurple.opacity(0.2))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
            }
            .offset(y: tab == .create ? -25 : 0)
            
            if tab != .create {
                Text(tab.title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(selectedTab == tab ? AppColors.primaryPurple : .gray)
                    .opacity(selectedTab == tab ? 1 : 0.7)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                selectedTab = tab
            }
        }
    }
    
    private func getIconColor(for tab: Tab) -> Color {
        if tab == .create {
            return .white
        }
        return selectedTab == tab ? AppColors.primaryPurple : .gray.opacity(0.8)
    }
} 
