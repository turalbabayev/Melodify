import SwiftUI

struct QuickStartCard: View {
    let onCreateTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Müzik Üretmeye Başla")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.9)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("AI ile kendi müziğini oluştur")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "waveform") // Sistem ikonuna geri dönüyoruz                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Button {
                onCreateTapped()
            } label: {
                HStack {
                    Text("Oluştur")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    AppColors.primaryPurple.opacity(0.3),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
        }
    }
} 
