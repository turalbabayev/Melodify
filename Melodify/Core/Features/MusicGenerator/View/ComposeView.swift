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
    @State private var isLyricsExpanded: Bool = true
    @State private var isStyleExpanded: Bool = true


    @ObservedObject var viewModel: MusicGeneratorViewModel

    var body: some View {
        VStack {
            //MARK: - Title Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Title")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isTitleExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isTitleExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, isLyricsExpanded ? 5 : 0)

                if isTitleExpanded {
                    VStack(alignment: .leading, spacing: 0) {
                        CustomTextEditor(text: $viewModel.prompt.title, placeholder: "Enter a title", maxCharacterLimit: 120, dynamicHeight: 20)
                            .padding(.bottom, 10)
                        
                        HStack{
                            
                            Spacer()
                            
                            // Karakter sayısını göster
                            Text("\(viewModel.prompt.title.count)/120")
                                .foregroundColor(viewModel.prompt.title.count >= 120 ? .purple : .white)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 24)

                        
                    }
                }
            }
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 8))
            
            //MARK: - Style of Music
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Style of Music")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isStyleExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isStyleExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, isLyricsExpanded ? 5 : 0)

                if isStyleExpanded {
                    VStack(alignment: .leading, spacing: 0) {
                        CustomTextEditor(text: $viewModel.prompt.title, placeholder: "Enter style of music", maxCharacterLimit: 120, dynamicHeight: 80)
                            .padding(.bottom, 10)
                        
                        HStack{
                            
                            Spacer()
                            
                            // Karakter sayısını göster
                            Text("\(viewModel.prompt.title.count)/120")
                                .foregroundColor(viewModel.prompt.title.count >= 120 ? .purple : .white)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 24)

                        
                    }
                }
            }
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 8))
            
            
            //MARK: - Lyrics Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Lyrics")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isLyricsExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isLyricsExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, isLyricsExpanded ? 5 : 0)

                if isLyricsExpanded {
                    VStack(alignment: .leading, spacing: 0) {
                        if !viewModel.prompt.isInstrumental {
                            CustomTextEditor(text: $viewModel.prompt.text, placeholder: "Write your own lyrics, two verses (8 lines) for the best result", maxCharacterLimit: 2999, dynamicHeight: 80)
                                .padding(.bottom, 10)
                                .transition(.opacity) // Opaklık animasyonu
                            
                            // Karakter sayısını göster
                            HStack{
                                Spacer()
                                Text("\(viewModel.prompt.text.count)/2999")
                                    .foregroundColor(viewModel.prompt.text.count >= 2999 ? .purple : .white)
                                    .font(.system(size: 12))
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 16)

                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 50)
                                .padding(.horizontal, 16)
                                .overlay(
                                    Text("Instrumental modda yazı yazamazsınız.")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .padding()
                                )
                                .transition(.opacity) // Opaklık animasyonu
                        }
                        
                        Toggle("Instrumental", isOn: $viewModel.prompt.isInstrumental)
                            .toggleStyle(SwitchToggleStyle(tint: Color.purple))
                            .padding(.horizontal, 16)
                            
                    }
                    .transition(.opacity) // Opaklık animasyonu
                    .animation(.easeInOut, value: viewModel.prompt.isInstrumental) // Animasyon
                }
            }
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)).padding(.horizontal, 5))
        }
    }
}

#Preview {
    ComposeView(viewModel: MusicGeneratorViewModel())
        .preferredColorScheme(.dark)
}
