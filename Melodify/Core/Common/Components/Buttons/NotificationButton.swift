import SwiftUI

struct NotificationButton: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showPaywall = false
    
    var body: some View {
        Button {
            showPaywall = true
        } label: {
            Image(systemName: "bell.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
} 
