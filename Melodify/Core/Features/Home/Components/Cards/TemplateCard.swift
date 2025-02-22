import SwiftUI

struct TemplateCard: View {
    let template: MusicTemplate
    let isHovered: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            HStack(spacing: 20) {
                // Sol taraf - İkon ve Başlık
                HStack(spacing: 16) {
                    // İkon Container
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
                    
                    // Başlık ve Açıklama
                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(template.description)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Sağ taraf - Kategori ve Ok
                HStack(spacing: 12) {
                    
                    Text(template.category)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(template.gradient[0])
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(template.backgroundColor)
                        }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(template.gradient[0])
                        .opacity(isHovered ? 1 : 0.7)
                        .offset(x: isHovered ? 4 : 0)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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
