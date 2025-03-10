//
//  MusicPrompt.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

struct MusicPrompt {
    var title: String = ""
    var lyrics: String = ""
    var styleofmusic: String = ""
    var text: String = ""
    var isInstrumental: Bool = false
    var prompt: String = ""
    var weirdness: Double = 0.5
    var lyricsStrength: Double = 0.5
    var selectedModel: String = "FUZZ-0.8"
    var start: Double = 0.0
    var end: Double = 4.0
}
