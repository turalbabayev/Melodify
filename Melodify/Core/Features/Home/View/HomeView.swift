import SwiftUI

/*
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        var index = 0
        
        while index < count {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
            index += size
        }
        
        return chunks
    }
}
 */

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var mainViewModel: MainViewModel
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                HomeNavigationBar(viewModel: viewModel)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                GreetingTextView()
                
                FeatureCardView()
                
                SectionHeaderView()
                
                TemplateSliderView(viewModel: viewModel)
                
                SectionHeaderView()

                /*
                // TemplateCardView'ları oluştur
                ForEach(viewModel.templates) { template in
                    TemplateCardView(template: template, height: 200)
                }
                .padding(.horizontal, 16)
                 */

            }
            .padding(.bottom, 48)
        }
        .background(AppColors.cardBackground)
    }
    
    
}

private struct GreetingTextView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
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
    }
}

private struct FeatureCardView: View {
    var body: some View {
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
        .padding(.horizontal, 16)
    }
}

private struct SectionHeaderView: View {
    var body: some View {
        HStack {
            Text("Trending Templates 🔥")
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // İşlem burada yapılacak.
            }) {
                Text("See all")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
    }
}

private struct TemplateSliderView: View {
    @State var currentIndex: Int = 0 //ANIMATED VIEW
    @State var currentTab: String = "English"
    @State var templateDetail: TemplateCardModel?
    @State var showMovieDetail: Bool = false
    @State var currentCardSize: CGSize = .zero
    @ObservedObject var viewModel: HomeViewModel

    @Environment(\.colorScheme) var scheme
    @Namespace var animation
    
    var body: some View {
        // MARK: SLIDER
        SnapCarousel(spacing: 20, trialingSpace: 110, index: $currentIndex, items: viewModel.templates) { template in
            GeometryReader { proxy in
                let size = proxy.size
                
                Image(template.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: 200)
                    .cornerRadius(15)
                    .matchedGeometryEffect(id: template.id, in: animation)
                    .onTapGesture {
                        currentCardSize = size
                        templateDetail = template
                        withAnimation(.easeInOut) {
                            showMovieDetail = true
                        }
                    }
            } // END GR
        } // END SLIDER
        .padding(.top, 70)
        
        Spacer()
    }
}

#Preview {
    HomeView(mainViewModel: MainViewModel())
        .preferredColorScheme(.dark)
} 
