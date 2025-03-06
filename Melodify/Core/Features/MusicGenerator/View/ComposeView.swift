//
//  ComposeView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

struct ComposeView: View {
    @Namespace private var animation // Animasyon için namespace
    @State private var isExpanded: Bool = true
    @ObservedObject var viewModel: MusicGeneratorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Lyrics")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 5)

            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    if !viewModel.prompt.isInstrumental {
                        CustomTextEditor(text: $viewModel.prompt.text, placeholder: "Bir şeyler yazın...")
                            .padding(.bottom, 10)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.purple.opacity(0.7))
                            .frame(height: 50)
                            .padding(.horizontal, 16)
                            .overlay(
                                Text("Instrumental modda yazı yazamazsınız.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                    .padding()
                            )
                            .transition(.scale) // Ölçek animasyonu
                            .animation(.easeInOut, value: viewModel.prompt.isInstrumental)
                    }
                    
                    Toggle("Instrumental", isOn: $viewModel.prompt.isInstrumental)
                        .toggleStyle(SwitchToggleStyle(tint: Color.purple))
                        .padding(.horizontal, 16)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isExpanded)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    ComposeView(viewModel: MusicGeneratorViewModel())
        .preferredColorScheme(.dark)
}
