import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $viewModel.selectedTab) {
                    HomeView(mainViewModel: viewModel)
                        .tag(Tab.home)
                    
                    SearchView()
                        .tag(Tab.search)
                    
                    MusicGeneratorView()
                        .tag(Tab.create)
                    
                    LibraryView()
                        .tag(Tab.library)
                    
                    SettingsView()
                        .tag(Tab.settings)
                }
                .animation(.none, value: viewModel.selectedTab)
                .gesture(DragGesture())
                
                // MiniPlayer'ı kaldırdık, sadece TabBar kaldı
                CustomTabBar(selectedTab: $viewModel.selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
} 


#Preview {
    MainView()
}
