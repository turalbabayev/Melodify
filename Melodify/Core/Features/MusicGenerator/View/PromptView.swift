//
//  PromptView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2024.
//

import SwiftUI

struct PromptView: View {
    @StateObject var viewModel: MusicGeneratorViewModel
    @State private var isPromptExpanded: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            promptSection
            instrumentalToggleSection
            saveButton
            creaditDisplay
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
            CustomTextEditor(text: $viewModel.musicPrompt.prompt,
                           placeholder: "Write your prompt",
                           maxCharacterLimit: 400,
                           dynamicHeight: 80)
                .padding(.bottom, 10)
            
            characterCountView
        }
    }
    
    // MARK: - Instrumental Toggle Section
    private var instrumentalToggleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Instrumental", isOn: $viewModel.musicPrompt.instrumental)
                .toggleStyle(SwitchToggleStyle(tint: Color.purple))
                .padding(.horizontal, 16)
                .font(.system(size: 14))
                .fontWeight(.bold)
        }
        .padding(.vertical)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 5))
    }
    
    //MARK: - Remaning Creadits Section
    private var creaditDisplay: some View {
        HStack {
            Image(systemName: "creditcard")
                .foregroundColor(.purple)
            Text("remaning_credits".localized)
                .foregroundColor(.gray)
            Text("\(viewModel.remainingCredits)")
                .foregroundColor(.gray)
        }
        .padding(.top, 10)
    }
    
    
    
    // MARK: - Character Count View
    private var characterCountView: some View {
        HStack {
            Spacer()
            Text("\(viewModel.musicPrompt.prompt.count)/400")
                .foregroundColor(viewModel.musicPrompt.prompt.count >= 400 ? .purple : .white)
                .font(.system(size: 12))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        CustomButton(title: "Generate") {
            viewModel.generateMusicFromPrompt()
        }
        .disabled(viewModel.isLoading)
        .padding(.bottom, 16)
    }
}

