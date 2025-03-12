import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $mainViewModel.selectedTab) {
                HomeView(mainViewModel: mainViewModel)
                    .tag(Tab.home)
                
                //PlaylistView()
                PlaylistView()
                    .tag(Tab.playlist)
                
                MusicGeneratorView(mainViewModel: mainViewModel)
                    .tag(Tab.create)
                
                LibraryView(mainViewModel: mainViewModel)
                    .tag(Tab.library)
                
                SettingsView()
                    .tag(Tab.settings)
            }
            
            CustomTabBar(selectedTab: $mainViewModel.selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainView()
}
