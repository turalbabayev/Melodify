import SwiftUI

struct LanguageView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    
    private let languages = [
        Language(name: "English", code: "en", flag: "🇺🇸"),
        Language(name: "Türkçe", code: "tr", flag: "🇹🇷")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.purple.opacity(0.15))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.purple)
                            )
                        
                        Text("Settings")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Header
            VStack(spacing: 8) {
                Text("Choose Your Language")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Select your preferred language")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 32)
            
            // Language Options
            VStack(spacing: 16) {
                ForEach(languages.indices, id: \.self) { index in
                    let language = languages[index]
                    Button {
                        withAnimation(.spring()) {
                            viewModel.selectedLanguage = index
                        }
                        dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            // Flag Circle
                            Text(language.flag)
                                .font(.system(size: 32))
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.3))
                                )
                            
                            // Language Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(language.name)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(language.code.uppercased())
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Selection Indicator
                            ZStack {
                                Circle()
                                    .stroke(viewModel.selectedLanguage == index ? Color.purple : Color.gray.opacity(0.3), lineWidth: 2)
                                    .frame(width: 24, height: 24)
                                
                                if viewModel.selectedLanguage == index {
                                    Circle()
                                        .fill(Color.purple)
                                        .frame(width: 16, height: 16)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(
                                            viewModel.selectedLanguage == index ? Color.purple.opacity(0.5) : Color.clear,
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(Color.black.opacity(0.9))
        .navigationBarHidden(true)
    }
}

// Button Animation Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Language Model
struct Language {
    let name: String
    let code: String
    let flag: String
}

#Preview {
    LanguageView(viewModel: SettingsViewModel())
        .preferredColorScheme(.dark)
} 
