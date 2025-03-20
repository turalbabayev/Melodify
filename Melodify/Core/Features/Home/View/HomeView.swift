import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HomeNavigationBar(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    GreetingTextView(viewModel: viewModel)
                    
                    FeatureCardView(mainViewModel: mainViewModel)
                    
                    SectionHeaderView()
                    
                    SectionFooterView(viewModel: viewModel)
                }
                .padding(.bottom, 48)
            }
            .background(LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.3),
                    //Color.blue.opacity(0.2),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea())
        }
        .environmentObject(mainViewModel)
    }
    
    
}

private struct GreetingTextView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(viewModel.greetingText)! \(viewModel.userName) 👋")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                
                Spacer()
            }
            
            Text(viewModel.subHeadlineText)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
    }
}

private struct FeatureCardView: View {
    @ObservedObject var mainViewModel: MainViewModel
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // SOLDaki Büyük Kart
            LargeFeatureCardView(
                title: "main_large_card_title".localized,
                subtitle: "main_large_card_subtitle".localized,
                buttonText: "main_large_card_buttontext".localized,
                iconName: "bolt.fill",
                buttonAction: {
                    mainViewModel.navigateToCreate()
                })
            
            // SAĞda 2 Küçük Kart
            VStack(spacing: 16) {
                SmallFeatureCardView(
                    title: "main_small_card_title1".localized,
                    buttonText: "main_small_card_buttontext".localized,
                    iconName: "music.note", buttonAction: {
                        mainViewModel.navigateToCreate()
                    }
                )
                
                SmallFeatureCardView(
                    title: "main_small_card_title2".localized,
                    buttonText: "main_small_card_buttontext".localized,
                    iconName: "mic.fill") {
                        mainViewModel.navigateToCreate()
                    }
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct SectionHeaderView: View {
    var body: some View {
        HStack {
            Text("Music Categories 🎵")
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
    }
}

private struct SectionFooterView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    let categories = MusicCategory.categories
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Sol kolon
            VStack {
                ForEach(categories.prefix(categories.count / 2), id: \.self) { category in
                    NavigationLink(destination: MusicCategoryDetailView(
                        category: category,
                        mainViewModel: mainViewModel
                    )) {
                        CategoryCardView(category: category)
                    }
                }
            }
            
            // Sağ kolon
            VStack {
                ForEach(categories.suffix(categories.count / 2), id: \.self) { category in
                    NavigationLink(destination: MusicCategoryDetailView(
                        category: category,
                        mainViewModel: mainViewModel
                    )) {
                        CategoryCardView(category: category)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// Yeni kategori kartı view'ı
private struct CategoryCardView: View {
    let category: MusicCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Kategori resmi
            Image(category.imageName)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: CGFloat.random(in: 130...300))
                .overlay(
                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(0.3),
                            .black.opacity(0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Kategori bilgileri
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text(category.description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

#Preview {
    HomeView(mainViewModel: MainViewModel())
        .preferredColorScheme(.dark)
} 
