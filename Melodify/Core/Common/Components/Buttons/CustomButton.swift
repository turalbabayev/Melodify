import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var backgroundColor: Color = Color.purple // Varsayılan arka plan rengi
    var foregroundColor: Color = Color.white // Varsayılan metin rengi
    var cornerRadius: CGFloat = 12 // Köşe yuvarlama
    var padding: CGFloat = 16 // İçerik için padding

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity) // Butonun genişliğini maksimum yap
                .padding(padding)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Gölge efekti
        }
        .padding(.horizontal, 16) // Butonun yanlarında padding
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Örnek Buton", action: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
} 