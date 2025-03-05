//
//  MusicGeneratorView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

struct MusicGeneratorView: View {
    @StateObject private var viewModel = MusicGeneratorViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                
                HeaderView()
                
                
                
                Text("adfjfdsjfdsf")
            }
            

        }
        .background(AppColors.cardBackground)
    }
    
}

private struct HeaderView:View {
    @StateObject private var viewModel = MusicGeneratorViewModel()

    var body: some View {
        HStack {
            Spacer()
            Button(action: { viewModel.selectedTab = .prompt }) {
                Text("Prompt")
                    .foregroundColor(viewModel.selectedTab == .prompt ? .white : .gray)
                    .font(.system(size: 16, weight: .semibold))
            }
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(viewModel.selectedTab == .prompt ? .white : .clear)
                    .offset(y: 12)
                , alignment: .bottom
            )
            
            Spacer()
            Button(action: { viewModel.selectedTab = .compose }) {
                Text("Compose")
                    .foregroundColor(viewModel.selectedTab == .compose ? .white : .gray)
                    .font(.system(size: 16, weight: .semibold))
            }
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(viewModel.selectedTab == .compose ? .white : .clear)
                    .offset(y: 12)
                , alignment: .bottom
            )
            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 5)
        
        Divider()
            .foregroundStyle(.white)
        
        if viewModel.selectedTab == .prompt {
            PromptView(viewModel: viewModel)
        } else {
            //ComposeView(viewModel: viewModel)
        }
    }
}

#Preview {
    MusicGeneratorView()
}
