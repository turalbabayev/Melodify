//
//  ComposeView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

struct ComposeView: View {
    @Namespace private var animation // Animasyon için namespace
    @State private var isTitleExpanded: Bool = true
    @State private var isLyricsExpanded: Bool = false // Şarkı sözleri bölümü başlangıçta kapalı
    @State private var isStyleExpanded: Bool = true

    @StateObject var viewModel: MusicGeneratorViewModel

    var body: some View {
        VStack(spacing: 16) {
            titleSection
            styleSection
            instrumentalToggleSection
            lyricsSection
            saveButton
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error ?? "")
        }
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        Button {
            withAnimation {
                isTitleExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Title")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: isTitleExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, isLyricsExpanded ? 5 : 0)

                if isTitleExpanded {
                    titleTextField
                }
            }
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var titleTextField: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomTextEditor(text: $viewModel.musicPrompt.title, placeholder: "Enter a title", maxCharacterLimit: 120, dynamicHeight: 20)
                .padding(.bottom, 10)

            
            HStack {
                Spacer()
                Text("\(viewModel.musicPrompt.title.count)/120")
                    .foregroundColor(viewModel.musicPrompt.title.count >= 120 ? .purple : .white)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 16)

        }
        
    }
    
    // MARK: - Style Section
    private var styleSection: some View {
        Button {
            withAnimation {
                isStyleExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Style of Music")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: isStyleExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, isLyricsExpanded ? 5 : 0)

                if isStyleExpanded {
                    styleTextField
                }
            }
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 5))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var styleTextField: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomTextEditor(text: $viewModel.musicPrompt.style, placeholder: "Enter style of music", maxCharacterLimit: 120, dynamicHeight: 80)
                .padding(.bottom, 10)
            
            HStack {
                Spacer()
                Text("\(viewModel.musicPrompt.style.count)/120")
                    .foregroundColor(viewModel.musicPrompt.style.count >= 120 ? .purple : .white)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 16)
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
    
    // MARK: - Lyrics Section
    private var lyricsSection: some View {
        Group {
            if !viewModel.musicPrompt.instrumental {
                Button {
                    withAnimation {
                        isLyricsExpanded.toggle()
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Lyrics")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: isLyricsExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, isLyricsExpanded ? 5 : 0)

                        if isLyricsExpanded {
                            lyricsTextField
                        }
                    }
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 5))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var lyricsTextField: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomTextEditor(text: $viewModel.musicPrompt.lyrics, placeholder: "Write your own lyrics, two verses (8 lines) for the best result", maxCharacterLimit: 2999, dynamicHeight: 80)
                .padding(.bottom, 10)
                .transition(.opacity) // Opaklık animasyonu
            
            HStack {
                Spacer()
                Text("\(viewModel.musicPrompt.lyrics.count)/2999")
                    .foregroundColor(viewModel.musicPrompt.lyrics.count >= 2999 ? .purple : .white)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        CustomButton(title: "Generate") {
            viewModel.generateMusicFromCompose()
        }
        .disabled(viewModel.isLoading)
        .padding(.bottom, 16)
    }
}


