import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @State private var showPaywall = false
    private let userService = UserService.shared
    
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
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onAppear {
            // MainView görüntülendiğinde (LaunchScreen'den sonra) Paywall'ı göster
            if userService.currentUser?.subscription == .free {
                showPaywall = true
            }
        }
    }
}

#Preview {
    MainView()
}
