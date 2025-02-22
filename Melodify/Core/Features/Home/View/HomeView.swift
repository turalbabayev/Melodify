import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HomeNavigationBar(viewModel: viewModel)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                QuickStartCard {
                    mainViewModel.selectedTab = .create
                }
                .padding(.horizontal, 16)
                
                PopularStylesSection()
                    .padding(.horizontal, 16)
                
                TemplatesSection(viewModel: viewModel)
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 48)
        }
        .background(AppColors.cardBackground)
    }
}

#Preview {
    HomeView(mainViewModel: MainViewModel())
        .preferredColorScheme(.dark)
} 
