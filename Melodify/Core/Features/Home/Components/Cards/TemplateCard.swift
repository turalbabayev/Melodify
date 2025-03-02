import SwiftUI

struct TemplateCardView: View {
    let template: TemplateCardModel
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Görsel yükleme
                Image(template.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width ,height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)

                // 🔹 Siyah Gradient Overlay
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: height) // Gradient'in boyutunu ayarladık
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 4) {
                    Text(template.category.uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(template.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(template.styleDescription)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(1)
                }
                .padding(12)
            }
            .padding(8) // Kartlar arasında boşluk
            //.background(Color.white.opacity(0.1)) // Arka plan rengi
            .frame(height: height)
            .cornerRadius(20) // Kart köşe yuvarlama
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5) // Kart gölgesi
        }
    }
}

#Preview {
    TemplateCardView(template: TemplateCardModel(imageName: "template1", category: "Pop", title: "Deneme Muzik Ismi", styleDescription: "DSDSD"), height: 220)
}
