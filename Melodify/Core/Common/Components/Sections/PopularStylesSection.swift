import SwiftUI

struct PopularStylesSection: View {
    @State private var hoveredStyle: MusicStyle?
    
    let styles: [MusicStyle] = [
        .init(title: "Hip Hop", icon: "music.note.list", gradient: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")]),
        .init(title: "Pop", icon: "music.mic", gradient: [Color(hex: "4E65FF"), Color(hex: "92EFFD")]),
        .init(title: "Rock", icon: "guitars", gradient: [Color(hex: "FF8C42"), Color(hex: "FEB47B")]),
        .init(title: "Electronic", icon: "waveform.path", gradient: [Color(hex: "9B4BFF"), Color(hex: "BE8CFF")]),
        .init(title: "Jazz", icon: "music.quarternote.3", gradient: [Color(hex: "3AB795"), Color(hex: "86E3BC")])
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Başlık ve Tümünü Gör butonu
            HStack {
                Text("Popüler Tarzlar")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    // Tümünü gör
                } label: {
                    Text("Tümünü Gör")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppColors.primaryPurple)
                }
            }
            
            // Yatay kaydırmalı kartlar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(styles) { style in
                        StyleCard(style: style, isHovered: hoveredStyle == style)
                            .onHover { isHovered in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    hoveredStyle = isHovered ? style : nil
                                }
                            }
                    }
                }
            }
            .mask(
                HStack(spacing: 0) {
                    LinearGradient(
                        colors: [.black, .black],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    LinearGradient(
                        colors: [.black, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 32)
                }
            )
        }
    }
}

struct StyleCard: View {
    let style: MusicStyle
    let isHovered: Bool
    
    var body: some View {
        Button {
            // Stil seçildiğinde yapılacak işlem
        } label: {
            HStack(spacing: 12) {
                // İkon
                Circle()
                    .fill(
                        LinearGradient(
                            colors: style.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: style.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    .shadow(color: style.gradient[0].opacity(0.3), radius: 8, x: 0, y: 4)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Başlık
                    Text(style.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    // Alt başlık
                    Text("Keşfet")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray)
                    .opacity(isHovered ? 1 : 0.7)
                    .offset(x: isHovered ? 4 : 0)
            }
            .frame(width: 180)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.03))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isHovered ? 0.2 : 0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(
                        color: style.gradient[0].opacity(isHovered ? 0.15 : 0),
                        radius: 12,
                        x: 0,
                        y: 6
                    )
            }
            .offset(y: isHovered ? -4 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovered)
    }
}

struct MusicStyle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let gradient: [Color]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MusicStyle, rhs: MusicStyle) -> Bool {
        lhs.id == rhs.id
    }
} 
