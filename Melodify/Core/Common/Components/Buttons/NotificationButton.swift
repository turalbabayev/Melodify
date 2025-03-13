import SwiftUI

struct NotificationButton: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Button {
            viewModel.togglePremium()
        } label: {
            Image(systemName: viewModel.subscriptionType == .premium ? "bell.fill" : "bell")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background {
                    Circle()
                        .fill(Color(UIColor.systemGray6).opacity(0.1))
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        }
                }
        }
    }
} 
