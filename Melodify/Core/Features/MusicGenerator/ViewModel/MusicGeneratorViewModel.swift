//
//  MusicGeneratorViewModel.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

class MusicGeneratorViewModel: ObservableObject {
    @Published var prompt = MusicPrompt()
    @Published var selectedTab: Tab = .prompt
    let models = ["FUZZ-0.8", "FUZZ-1.0", "CLASSIC-0.5"]
    
    enum Tab {
        case prompt, compose
    }
    
    func generateMusic() {
        print("Generating music with prompt: \(prompt.lyrics)")
    }
}
