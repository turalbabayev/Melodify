import SwiftUI

struct CreditDisplay: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Credits Available")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.gray)
            
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, options: .repeating)
                
                Text("\(viewModel.credits)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                if viewModel.subscriptionType == .premium {
                    Text("PRO")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
        }
    }
} 
