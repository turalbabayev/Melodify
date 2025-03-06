//
//  PromptView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

struct PromptView: View {
    @ObservedObject var viewModel: MusicGeneratorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Prompt")
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 5)
                .padding(.horizontal,16)
            
            CustomTextEditor(text: $viewModel.prompt.text, placeholder: "Bir şeyler yazın...")
                .padding(.bottom, 10)
            
            Toggle("Instrumental", isOn: $viewModel.prompt.isInstrumental)
                .toggleStyle(SwitchToggleStyle(tint: Color.purple))
                .padding(.horizontal, 16)

            
        }
        .padding(.vertical)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 5))
        .padding(.top, 16)
        
        Spacer()
        
        Button(action: {}) {
            HStack {
                Image(systemName: "sparkles")
                Text("Oluştur")
                    .fontWeight(.regular)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.purple.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)

    }
}

/*
struct CustomTextEditor: View {
    @Binding var text: String
    var placeholder: String = "Write something..."
    var charLimit: Int? = nil
    
    @State private var dynamicHeight: CGFloat = 100
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            
            CustomUITextView(text: $text, dynamicHeight: $dynamicHeight)
                .frame(minHeight: dynamicHeight, maxHeight: 200)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.cardBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
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
        textView.backgroundColor = UIColor.clear // Arka planı tamamen kaldır
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.white
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
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
                self.parent.dynamicHeight = max(80, estimatedHeight + 20)
            }
        }
    }
}

 */
#Preview {
    PromptView(viewModel: MusicGeneratorViewModel())
        .preferredColorScheme(.dark)
}
