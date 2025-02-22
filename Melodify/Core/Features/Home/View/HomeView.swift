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
        .background(AppColors.cardBackground)
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
} 