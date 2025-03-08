//
//  PromptView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2024.
//

import SwiftUI

struct PromptView: View {
    @ObservedObject var viewModel: MusicGeneratorViewModel
    @State private var isPromptExpanded: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            promptSection
            saveButton
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
    
    // MARK: - Prompt Section
    private var promptSection: some View {
        Button {
            withAnimation {
                isPromptExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Prompt")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: isPromptExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                
                if isPromptExpanded {
                    promptTextField
                }
            }
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Prompt TextField
    private var promptTextField: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomTextEditor(text: $viewModel.prompt.prompt,
                           placeholder: "Write your prompt",
                           maxCharacterLimit: 2999,
                           dynamicHeight: 80)
                .padding(.bottom, 10)
            
            characterCountView
        }
    }
    
    // MARK: - Character Count View
    private var characterCountView: some View {
        HStack {
            Spacer()
            Text("\(viewModel.prompt.prompt.count)/2999")
                .foregroundColor(viewModel.prompt.prompt.count >= 2999 ? .purple : .white)
                .font(.system(size: 12))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        CustomButton(title: "Kaydet") {
            // Butona tıklandığında yapılacak işlemler
            print("Butona tıklandı!")
        }
        .padding(.bottom, 16)
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
