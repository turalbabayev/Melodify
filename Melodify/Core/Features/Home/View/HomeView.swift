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
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HomeNavigationBar(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    GreetingTextView()
                    
                    FeatureCardView()
                    
                    SectionHeaderView()
                    
                    //TemplateSliderView(viewModel: viewModel)
                    
                    //CarouselView()
                    
                    HStack(alignment: .top, spacing: 5) {
                        VStack{
                            ForEach(viewModel.templates.prefix(viewModel.templates.count / 2), id: \.self) { template in
                                Image(template.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: CGFloat.random(in: 130...300))
                                    .cornerRadius(10)
                            }
                        }
                        VStack{
                            ForEach(viewModel.templates.suffix(viewModel.templates.count / 2), id: \.self) { template in
                                Image(template.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: CGFloat.random(in: 130...300))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                                    
                    /*
                    LazyVStack(spacing: 16) {
                        CompositionalLayout {
                            ForEach(viewModel.templates) { template in
                                Image(template.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                     */
                    
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

struct TemplateSliderView: View {
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

struct CarouselView: View {
    
    var xDistance: Int = 150
    
    @State private var snappedItem = 0.0
    @State private var draggingItem = 1.0
    @State private var activeIndex: Int = 0
    
    var views: [CarouselViewChild] = placeholderCarouselChildView
    
    var body: some View {
        ZStack {
            ForEach(views) { view in
                view
                    .scaleEffect(1.0 - abs(distance(view.id)) * 0.2)
                    .opacity(1.0 - abs(distance(view.id)) * 0.3)
                    .offset(x: getOffset(view.id), y: 0)
                    .zIndex(1.0 - abs(distance(view.id)) * 0.1)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = snappedItem + value.translation.width / 100
                }
                .onEnded { value in
                    withAnimation {
                        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                        draggingItem = round(draggingItem).remainder(dividingBy: Double(views.count))
                        snappedItem = draggingItem
                        self.activeIndex = views.count + Int(draggingItem)
                        if self.activeIndex > views.count || Int(draggingItem) >= 0 {
                            self.activeIndex = Int(draggingItem)
                        }
                    }
                }
        )
        
    }
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item).remainder(dividingBy: Double(views.count)))
    }
    
    func getOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(views.count) * distance(item)
        return sin(angle) * Double(xDistance)
        
    }
    
}

struct CarouselViewChild: View, Identifiable {
    var id: Int
    @ViewBuilder var content: any View
    
    var body: some View {
        ZStack {
            AnyView(content)
        }
    }
}

var placeholderCarouselChildView: [CarouselViewChild] = [
    
    CarouselViewChild(id: 1, content: {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.red)
            Text("1")
                .padding()
        }
        .frame(width: 200, height: 200)
    }),
    
    CarouselViewChild(id: 2, content: {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.red)
            Text("2")
                .padding()
        }
        .frame(width: 200, height: 200)
    }),
    
    CarouselViewChild(id: 3, content: {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.red)
            Text("3")
                .padding()
        }
        .frame(width: 200, height: 200)
    })
    
]

#Preview {
    HomeView(mainViewModel: MainViewModel())
        .preferredColorScheme(.dark)
} 
