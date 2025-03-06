import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String
    var placeholder: String = "Write something..."
    
    @State private var dynamicHeight: CGFloat = 100
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CustomUITextView(text: $text, dynamicHeight: $dynamicHeight)
                .frame(minHeight: dynamicHeight, maxHeight: .infinity) // Yüksekliği dinamik olarak ayarlayın
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.cardBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .frame(maxWidth: UIScreen.main.bounds.width - 40) // Genişliği sabit tut

            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
            }
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut, value: text)
    }
}

struct CustomUITextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.white
        textView.isScrollEnabled = false // Scroll'u kapat
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        
        // Metin taşmasını önlemek için ayarlar
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0 // Sınırsız satır
        textView.textContainer.lineFragmentPadding = 0 // Kenar boşluğunu sıfırla
        
        // Genişliği sınırlamak için
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true // Ekran genişliğinden 32 birim çıkar
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.isScrollEnabled = false // Scroll'u kapat
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomUITextView
        
        init(_ parent: CustomUITextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text
                let size = CGSize(width: textView.frame.width, height: .infinity)
                let estimatedHeight = textView.sizeThatFits(size).height
                self.parent.dynamicHeight = max(80, estimatedHeight + 20) // Minimum yükseklik
            }
        }
    }
} 
