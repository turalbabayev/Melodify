import SwiftUI

struct MiniPlayer: View {
    @State private var isPlaying: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Arka plan bar
                    Rectangle()
                        .fill(.white.opacity(0.1))
                        .frame(height: 2)
                    
                    // İlerleme barı
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.4)
                        .frame(height: 2)
                }
            }
            .frame(height: 2)
            
            HStack(spacing: 16) {
                // Müzik resmi
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryPurple.opacity(0.3), AppColors.secondaryBlue.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: "waveform")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.2),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                
                // Müzik bilgisi
                VStack(alignment: .leading, spacing: 4) {
                    Text("Yapay Zeka Müziği")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.9)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Melodify AI")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                // Kontrol butonları
                HStack(spacing: 20) {
                    Button {
                        // Önceki şarkı
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                            .overlay {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(.white)
                            }
                    }
                    
                    Button {
                        // Sonraki şarkı
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                Rectangle()
                    .fill(AppColors.cardBackground)
                    .overlay {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 1)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
            }
        }
    }
} 