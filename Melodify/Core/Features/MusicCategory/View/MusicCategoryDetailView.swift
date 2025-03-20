import SwiftUI

struct MusicCategoryDetailView: View {
    let category: MusicCategory
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var mainViewModel: MainViewModel
    @State private var selectedLanguage: String = "all" // "all", "tr", "en"
    
    var filteredPrompts: [MusicPromptTemplate] {
        if selectedLanguage == "all" {
            return category.prompts
        }
        return category.prompts.filter { $0.language == selectedLanguage }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - Hero Section
                    ZStack(alignment: .top) {
                        // Background Image
                        Image(category.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 360)
                            .overlay(
                                LinearGradient(
                                    colors: [
                                        .black.opacity(0.3),
                                        .black.opacity(0.5),
                                        .black
                                    ],
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                            .clipped()
                    }
                    
                    // MARK: - Content Section
                    VStack(alignment: .leading, spacing: 0) {
                        // Category Info
                        VStack(alignment: .leading, spacing: 20) {
                            Text(category.name)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 24) {
                                Label("\(category.prompts.count) Templates", systemImage: "music.note.list")
                                Label("AI Generated", systemImage: "cpu")
                            }
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.top, 32)
                        
                        // Description
                        Text(category.description)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .lineSpacing(5)
                            .padding(.horizontal)
                            .padding(.top, 24)
                        
                        // Language Filter
                        Picker("Language", selection: $selectedLanguage) {
                            Text("All").tag("all")
                            Text("Türkçe").tag("tr")
                            Text("English").tag("en")
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        // Templates Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Templates")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top, 32)
                            
                            ForEach(filteredPrompts) { prompt in
                                TemplateCard(prompt: prompt) {
                                    mainViewModel.navigateToCreateWithPrompt(prompt)
                                }
                            }
                        }
                        .padding(.bottom, 140)
                    }
                    .background(Color.black)
                }
            }
            
            // Back Button - Her zaman görünür
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 60)
            .background(
                LinearGradient(
                    colors: [
                        .black.opacity(0.3),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 104)
                .ignoresSafeArea()
            )
        }
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onDisappear { dismiss() }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissDetailView"))) { _ in
            dismiss()
        }
    }
}

// MARK: - Template Card
struct TemplateCard: View {
    let prompt: MusicPromptTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 20) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(prompt.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text(prompt.style)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    if prompt.isInstrumental {
                        Text("Instrumental")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.purple)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.purple.opacity(0.15))
                            .cornerRadius(20)
                    }
                }
                
                // Description & Button
                HStack(alignment: .bottom) {
                    Text(prompt.description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(
                                LinearGradient(
                                    colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Circle())
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
            .padding(.horizontal)
        }
    }
} 
