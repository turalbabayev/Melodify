import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HomeNavigationBar(viewModel: viewModel)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                            
                    HStack{
                        Text("\(viewModel.greetingMessage)! \(viewModel.userName) \(viewModel.greetingEmoji)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Spacer()
                    }
                    
                    Text(viewModel.subHeadline)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                                        
                }
                .padding(.horizontal, 16)
                
                HStack(alignment: .top, spacing: 16) {
                    // SOLDaki Büyük Kart
                    LargeFeatureCardView(
                        title: "AI Quick Music",
                        subtitle: "Create a track with just one prompt",
                        buttonText: "Start Generating",
                        iconName: "bolt.fill"
                    )
                    
                    // SAĞda 2 Küçük Kart
                    VStack(spacing: 16) {
                        SmallFeatureCardView(
                            title: "Instrumental",
                            buttonText: "Create new",
                            iconName: "music.note"
                        )
                        
                        SmallFeatureCardView(
                            title: "Vocal Song",
                            buttonText: "Create new",
                            iconName: "mic.fill"
                        )
                    }
                }
                .padding(.horizontal,16)

                /*
                QuickStartCard {
                    mainViewModel.selectedTab = .create
                }
                .padding(.horizontal, 16)
                
                PopularStylesSection()
                    .padding(.horizontal, 16)
                
                TemplatesSection(viewModel: viewModel)
                    .padding(.horizontal, 16)
                 */
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
