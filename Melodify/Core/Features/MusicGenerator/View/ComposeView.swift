//
//  ComposeView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

struct ComposeView: View {
    @State private var isExpanded: Bool = true
    @ObservedObject var viewModel: MusicGeneratorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Prompt")
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
                    CustomTextEditor(text: $viewModel.prompt.text, placeholder: "Bir şeyler yazın...")
                        .padding(.bottom, 10)
                    
                    Toggle("Instrumental", isOn: $viewModel.prompt.isInstrumental)
                        .toggleStyle(SwitchToggleStyle(tint: Color.purple))
                        .padding(.horizontal, 16)
                }
            }
            
            
        }
        .padding(.vertical)

    }
}

#Preview {
    ComposeView(viewModel: MusicGeneratorViewModel())
        .preferredColorScheme(.dark)
}
