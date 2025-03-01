import SwiftUI

struct TemplateCard: View {
    let template: MusicTemplate
    let isHovered: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                // Üst Kısım - İkon ve Kategori
                HStack {
                    Circle()
                        .fill(template.backgroundColor)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(systemName: template.icon)
                                .font(.system(size: 22))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: template.gradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .overlay {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: template.gradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                                .opacity(0.5)
                        }
                        .scaleEffect(isHovered ? 1.08 : 1)
                    
                    Spacer()
                    
                    Text(template.category)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(template.gradient[0])
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(template.backgroundColor)
                        }
                }
                
                // Başlık ve Açıklama
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(template.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }
                
                // Özellikler
                HStack(spacing: 12) {
                    // Stil
                    Label {
                        Text(template.style)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.gray)
                    } icon: {
                        Image(systemName: "music.note")
                            .font(.system(size: 12))
                            .foregroundStyle(template.gradient[0])
                    }
                    
                    // Tempo
                    Label {
                        Text(template.tempo)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.gray)
                    } icon: {
                        Image(systemName: "metronome")
                            .font(.system(size: 12))
                            .foregroundStyle(template.gradient[0])
                    }
                }
                
                // Alt Kısım - Kullan Butonu
                HStack {
                    Text("Use Prompt")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(template.gradient[0])
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(template.gradient[0])
                        .opacity(isHovered ? 1 : 0.7)
                        .offset(x: isHovered ? 4 : 0)
                }
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.03))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.06), lineWidth: 1)
                    }
            }
            .offset(y: isHovered ? -2 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovered)
    }
} 
