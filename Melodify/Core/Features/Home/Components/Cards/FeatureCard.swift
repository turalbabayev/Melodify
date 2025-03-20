import SwiftUI

// MARK: - Büyük Kart
struct LargeFeatureCardView: View {
    let title: String
    let subtitle: String
    let buttonText: String
    let iconName: String
    let buttonAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Arka Plan (Siyah + Mor swirl)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black)
                .overlay(
                    Image("purpleSwirl")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.5)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                
                // Ikon + Alt Başlık
                HStack(spacing: 6) {
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                        .font(.title3)
                    
                    Spacer()
                }
                .padding(.top, 16)
                
                Text(title)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.footnote) // Daha ufak, "AI Voice Generator"
                
                Spacer()
                
                // Büyük Metin
                Text(subtitle)
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .bold))
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                    .padding(.top, 4)
                    .padding(.trailing, 32)
                    .padding(.bottom, 4)
                
                
                // Alttaki Buton
                Button(action: {
                    buttonAction()
                }) {
                    Text(buttonText)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.primaryPurple)
                        )
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
        }
        // Kart boyutu (daha büyük yükseklik)
        .frame(width: 210, height: 310)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Küçük Kart
struct SmallFeatureCardView: View {
    let title: String
    let buttonText: String
    let iconName: String
    let buttonAction: () -> Void

    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black)
                .overlay(
                    Image("purpleSwirl")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                        .font(.body)
                    
                    Spacer()
                }
                .padding(.top, 12)
                
                Text(title)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.footnote)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        buttonAction()
                    }) {
                        Text(buttonText)
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .semibold))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.1))
                        )

                        
                }
                .padding(.bottom, 12)

            }
            .padding(.leading, 16)
            .padding(.trailing, 8)
        }
        // Kart boyutu
        .frame(width: 140, height: 147)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

