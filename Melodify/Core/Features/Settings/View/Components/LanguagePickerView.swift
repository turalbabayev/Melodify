import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("settings_choose_language".localized)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("done".localized) {
                    dismiss()
                }
                .foregroundColor(.purple)
            }
            .padding()
            
            // Language Options
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.languages) { language in
                        Button {
                            viewModel.updateLanguage(language)
                            dismiss()
                        } label: {
                            HStack(spacing: 16) {
                                // Bayrak ve dil adı
                                Text("\(language.flag) \(language.nativeName)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                // Seçili işareti
                                if language.code == viewModel.selectedLanguage.code {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.purple)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(language.code == viewModel.selectedLanguage.code ?
                                         Color.purple.opacity(0.1) : Color.clear)
                            )
                        }
                        
                        if language != viewModel.languages.last {
                            Divider()
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}
