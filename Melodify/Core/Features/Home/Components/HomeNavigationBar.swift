import SwiftUI

struct HomeNavigationBar: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            CreditDisplay(viewModel: viewModel)
            Spacer()
            NotificationButton()
        }
    }
} 