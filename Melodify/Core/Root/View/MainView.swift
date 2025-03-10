import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(mainViewModel: MainViewModel())
                    .tag(Tab.home)
                
                //PlaylistView()
                PlaylistView()
                    .tag(Tab.playlist)
                
                MusicGeneratorView()
                    .tag(Tab.create)
                
                LibraryView()
                    .tag(Tab.library)
                
                SettingsView()
                    .tag(Tab.settings)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainView()
}
