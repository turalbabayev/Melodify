//
//  MusicGeneratorView.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

struct MusicGeneratorView: View {
    @StateObject private var viewModel: MusicGeneratorViewModel
    @ObservedObject var mainViewModel: MainViewModel
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        let viewModel = MusicGeneratorViewModel(mainViewModel: mainViewModel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HeaderView(viewModel: viewModel)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            
        }
        .background(LinearGradient(
            colors: [
                Color.black,
                Color.purple.opacity(0.3),
                //Color.blue.opacity(0.2),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea())
        .alert("Out of Credits", isPresented: $viewModel.showCreditAlert) {
            Button("OK", role: .cancel) { }
            // İleride eklenecek satın alma sayfası için:
            // Button("Get More Credits") {
            //     // Navigate to purchase page
            // }
        } message: {
            Text("You don't have enough credits to generate music. Please purchase more credits to continue.")
        }
        .alert("Hata", isPresented: $viewModel.showErrorAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onAppear {
            // View yüklendiğinde set et
            mainViewModel.setMusicGeneratorViewModel(viewModel)
        }
    }
}

private struct HeaderView: View {
    @ObservedObject var viewModel: MusicGeneratorViewModel
    
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
                .padding(.bottom, 70)
            
        } else {
            ComposeView(viewModel: viewModel)
                .padding(.bottom, 70)
        }
    }
}

#Preview {
    MusicGeneratorView(mainViewModel: MainViewModel())
}
