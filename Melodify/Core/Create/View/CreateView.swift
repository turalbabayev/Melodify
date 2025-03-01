import SwiftUI

struct CreateView: View {
    @StateObject private var viewModel = CreateViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Başlık
            Text("Create Your Music")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            // Custom Mode Seçimi
            Toggle("Custom Mode", isOn: $viewModel.customMode)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.primaryPurple))
                .padding()
            
            // Instrumental Seçimi
            if viewModel.customMode {
                Toggle("Instrumental", isOn: $viewModel.instrumental)
                    .toggleStyle(SwitchToggleStyle(tint: AppColors.primaryPurple))
                    .padding()
            }
            
            // Title Girişi
            TextField("Title", text: $viewModel.title)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .foregroundColor(.black)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            // Prompt Girişi
            TextEditor(text: $viewModel.prompt)
                .frame(height: 150)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .foregroundColor(.black)
                .onReceive(viewModel.prompt.publisher.collect()) {
                    if $0.count > (viewModel.customMode ? 3000 : 400) {
                        viewModel.prompt = String($0.prefix(viewModel.customMode ? 3000 : 400))
                    }
                }
                .padding(.horizontal)
            
            // Style Girişi
            if viewModel.customMode && viewModel.instrumental {
                TextField("Style", text: $viewModel.style)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .onReceive(viewModel.style.publisher.collect()) {
                        if $0.count > 200 {
                            viewModel.style = String($0.prefix(200))
                        }
                    }
                    .padding(.horizontal)
            }
            
            // Create Butonu
            Button(action: {
                viewModel.createMusic()
            }) {
                Text("Create")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isFormValid ? 
                        AnyView(LinearGradient(colors: [AppColors.primaryPurple, AppColors.secondaryBlue], startPoint: .leading, endPoint: .trailing)) : 
                        AnyView(Color.gray)
                    )
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isFormValid)
            .padding(.horizontal)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
} 
